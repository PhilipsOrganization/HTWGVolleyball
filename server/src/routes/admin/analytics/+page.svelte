<script>
	import { onMount } from 'svelte';
	import Chart from 'chart.js/auto';

	let { data } = $props();

	/** @type {HTMLCanvasElement} */
	let distributionCanvas;
	/** @type {HTMLCanvasElement} */
	let activityCanvas;
	/** @type {HTMLCanvasElement} */
	let trajectoryCanvas;
	/** @type {Chart | null} */
	let distributionChart = null;
	/** @type {Chart | null} */
	let activityChart = null;
	/** @type {Chart | null} */
	let trajectoryChart = null;

	/** @type {{ username: string, maxScore: number, index: number }[]} */
	let legendItems = $state([]);
	let highlightedUser = $state(-1);

	/**
	 * @param {number} index
	 */
	function highlightUser(index) {
		highlightedUser = index;
		if (!trajectoryChart) return;
		trajectoryChart.data.datasets.forEach((dataset, i) => {
			if (i === index) {
				dataset.borderWidth = 5;
				dataset.borderColor = 'rgb(255, 255, 255)';
			} else {
				dataset.borderWidth = 0.5;
				dataset.borderColor = 'rgba(100, 100, 100, 0.15)';
			}
		});
		trajectoryChart.update('none');
	}

	function resetHighlight() {
		highlightedUser = -1;
		if (!trajectoryChart) return;
		trajectoryChart.data.datasets.forEach((dataset) => {
			// @ts-ignore
			const score = dataset.maxScore ?? 0;
			if (score >= 10) {
				dataset.borderWidth = 3;
				dataset.borderColor = 'rgb(34, 197, 94)';
			} else if (score >= 7) {
				dataset.borderWidth = 2.5;
				dataset.borderColor = 'rgba(34, 197, 94, 0.9)';
			} else if (score >= 5) {
				dataset.borderWidth = 2;
				dataset.borderColor = 'rgba(34, 197, 94, 0.75)';
			} else if (score >= 3) {
				dataset.borderWidth = 1.5;
				dataset.borderColor = 'rgba(100, 180, 140, 0.4)';
			} else if (score >= 1) {
				dataset.borderWidth = 0.75;
				dataset.borderColor = 'rgba(120, 120, 120, 0.12)';
			} else {
				dataset.borderWidth = 0.5;
				dataset.borderColor = 'rgba(80, 80, 80, 0.05)';
			}
		});
		trajectoryChart.update('none');
	}

	onMount(() => {
		// Score Distribution Histogram
		distributionChart = new Chart(distributionCanvas, {
			type: 'bar',
			data: {
				labels: data.scoreDistribution.map((d) => d.label),
				datasets: [
					{
						label: 'Number of Users',
						data: data.scoreDistribution.map((d) => d.count),
						backgroundColor: data.scoreDistribution.map((d, i) => {
							// Color gradient from yellow (low) to green (high)
							if (i === 0) return 'rgba(234, 179, 8, 0.6)'; // 0 score - yellow
							const greenIntensity = Math.min(0.8, 0.3 + i * 0.08);
							return `rgba(34, 197, 94, ${greenIntensity})`;
						}),
						borderColor: data.scoreDistribution.map((d, i) => {
							if (i === 0) return 'rgb(234, 179, 8)';
							return 'rgb(34, 197, 94)';
						}),
						borderWidth: 1
					}
				]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				plugins: {
					legend: {
						display: false
					},
					title: {
						display: true,
						text: 'User Consistency Score Distribution',
						color: '#e0e0e0',
						font: { size: 16, weight: 'normal' }
					},
					tooltip: {
						callbacks: {
							label: (ctx) => `${ctx.raw} users`
						}
					}
				},
				scales: {
					y: {
						beginAtZero: true,
						title: {
							display: true,
							text: 'Number of Users',
							color: '#888'
						},
						ticks: { color: '#888' },
						grid: { color: '#2a2a2a' }
					},
					x: {
						title: {
							display: true,
							text: 'Consistency Score',
							color: '#888'
						},
						ticks: { color: '#888' },
						grid: { color: '#2a2a2a' }
					}
				}
			}
		});

		// Weekly Activity Chart
		const recentWeeks = data.weeklyActivity.slice(-26); // Last 6 months

		activityChart = new Chart(activityCanvas, {
			type: 'line',
			data: {
				labels: recentWeeks.map((d) => {
					const date = new Date(d.week);
					return date.toLocaleDateString('de-DE', { month: 'short', day: 'numeric' });
				}),
				datasets: [
					{
						label: 'Total Bookings',
						data: recentWeeks.map((d) => d.bookings),
						borderColor: 'rgb(156, 193, 207)',
						backgroundColor: 'rgba(156, 193, 207, 0.1)',
						fill: true,
						tension: 0.3,
						yAxisID: 'y'
					},
					{
						label: 'Unique Users',
						data: recentWeeks.map((d) => d.uniqueUsers),
						borderColor: 'rgb(234, 179, 8)',
						backgroundColor: 'rgba(234, 179, 8, 0.1)',
						fill: true,
						tension: 0.3,
						yAxisID: 'y1'
					}
				]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				interaction: {
					mode: 'index',
					intersect: false
				},
				plugins: {
					title: {
						display: true,
						text: 'Weekly Activity (Last 6 Months)',
						color: '#e0e0e0',
						font: { size: 16, weight: 'normal' }
					},
					legend: {
						labels: { color: '#888' }
					}
				},
				scales: {
					y: {
						type: 'linear',
						display: true,
						position: 'left',
						title: {
							display: true,
							text: 'Bookings',
							color: '#888'
						},
						ticks: { color: '#888' },
						grid: { color: '#2a2a2a' }
					},
					y1: {
						type: 'linear',
						display: true,
						position: 'right',
						title: {
							display: true,
							text: 'Unique Users',
							color: '#888'
						},
						ticks: { color: '#888' },
						grid: { drawOnChartArea: false }
					},
					x: {
						ticks: { color: '#888', maxRotation: 45 },
						grid: { color: '#2a2a2a' }
					}
				}
			}
		});

		// User Score Trajectories (Spaghetti Chart)
		const { weeks, users: rawUsers } = data.userScoresOverTime;

		// Calculate max score for each user (highest score reached)
		const usersWithScore = rawUsers.map((user) => {
			const validScores = user.scores.filter((s) => s !== null);
			const maxScore = validScores.length > 0 ? Math.max(...validScores) : 0;
			const finalScore = validScores.pop() ?? 0;
			return { ...user, maxScore, finalScore };
		});

		// Sort by maxScore ascending so high scores are drawn last (on top)
		usersWithScore.sort((a, b) => a.maxScore - b.maxScore);

		// Generate colors and width for each user based on their MAX score
		const getLineStyle = (/** @type {number} */ maxScore) => {
			if (maxScore >= 10) return { color: 'rgb(34, 197, 94)', width: 3 }; // Bright green, thick, fully opaque
			if (maxScore >= 7) return { color: 'rgba(34, 197, 94, 0.9)', width: 2.5 };
			if (maxScore >= 5) return { color: 'rgba(34, 197, 94, 0.75)', width: 2 };
			if (maxScore >= 3) return { color: 'rgba(100, 180, 140, 0.4)', width: 1.5 };
			if (maxScore >= 1) return { color: 'rgba(120, 120, 120, 0.12)', width: 0.75 };
			return { color: 'rgba(80, 80, 80, 0.05)', width: 0.5 }; // Very faint for zero
		};

		const trajectoryDatasets = usersWithScore.map((user) => {
			const style = getLineStyle(user.maxScore);
			return {
				label: user.username,
				data: user.scores,
				borderColor: style.color,
				borderWidth: style.width,
				pointRadius: 0,
				tension: 0.2,
				fill: false,
				spanGaps: false,
				maxScore: user.maxScore,
				finalScore: user.finalScore
			};
		});

		// Create sorted legend data (top 30 users by max score, descending)
		const topUsers = [...usersWithScore].sort((a, b) => b.maxScore - a.maxScore);

		// Store legend items for HTML legend
		legendItems = topUsers.map((user) => ({
			username: user.username,
			maxScore: user.maxScore,
			index: usersWithScore.indexOf(user)
		}));

		trajectoryChart = new Chart(trajectoryCanvas, {
			type: 'line',
			data: {
				labels: weeks.map((w) => {
					const date = new Date(w);
					return date.toLocaleDateString('de-DE', { month: 'short', day: 'numeric' });
				}),
				datasets: trajectoryDatasets
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				animation: false,
				interaction: {
					mode: 'nearest',
					intersect: true
				},
				plugins: {
					title: {
						display: true,
						text: `User Consistency Scores Over Time (${usersWithScore.length} users)`,
						color: '#e0e0e0',
						font: { size: 16, weight: 'normal' }
					},
					legend: {
						display: false
					},
					tooltip: {
						enabled: true,
						backgroundColor: 'rgba(30, 30, 30, 0.95)',
						titleColor: '#fff',
						bodyColor: '#fff',
						borderColor: '#444',
						borderWidth: 1,
						callbacks: {
							// @ts-ignore
							label: (ctx) => `${ctx.dataset.label} (max: ${ctx.dataset.maxScore ?? 0}): ${ctx.raw ?? 'N/A'}`
						}
					}
				},
				scales: {
					y: {
						title: {
							display: true,
							text: 'Consistency Score',
							color: '#888'
						},
						ticks: { color: '#888' },
						grid: { color: '#2a2a2a' }
					},
					x: {
						ticks: {
							color: '#888',
							maxRotation: 45,
							autoSkip: true,
							maxTicksLimit: 20
						},
						grid: { color: '#2a2a2a' }
					}
				}
			}
		});

		return () => {
			distributionChart?.destroy();
			activityChart?.destroy();
			trajectoryChart?.destroy();
		};
	});
</script>

<main>
	<div class="page-header">
		<h1>User Analytics</h1>
		<span class="subtitle">Consistency tracking based on consecutive course bookings</span>
	</div>

	<div class="stats-row">
		<div class="stat-card">
			<span class="stat-value">{data.stats.totalUsers}</span>
			<span class="stat-label">Active Users</span>
		</div>
		<div class="stat-card">
			<span class="stat-value">{data.stats.totalBookings}</span>
			<span class="stat-label">Total Bookings</span>
		</div>
		<div class="stat-card positive">
			<span class="stat-value">{data.stats.positiveScoreUsers}</span>
			<span class="stat-label">Score &gt; 0</span>
		</div>
		<div class="stat-card neutral">
			<span class="stat-value">{data.stats.negativeScoreUsers}</span>
			<span class="stat-label">Score = 0</span>
		</div>
		<div class="stat-card">
			<span class="stat-value">{data.stats.avgScore}</span>
			<span class="stat-label">Avg Score</span>
		</div>
	</div>

	<div class="info-box">
		<strong>How scores work:</strong> Users earn +1 point when booking the same course in consecutive weeks, and lose -1 point for each week missed
		(clamped at 0). Higher scores indicate more consistent attendance.
	</div>

	<div class="trajectory-container">
		<div class="chart-card chart-full">
			<canvas bind:this={trajectoryCanvas}></canvas>
		</div>
		<div class="custom-legend" role="list" onmouseleave={() => resetHighlight()}>
			<h3>Top Users (by max score)</h3>
			{#each legendItems as item}
				<button
					class="legend-item"
					class:highlighted={highlightedUser === item.index}
					onmouseenter={() => highlightUser(item.index)}
					onclick={() => highlightUser(item.index)}
				>
					<span class="legend-color" style="background: {item.maxScore >= 7 ? 'rgb(34, 197, 94)' : 'rgba(34, 197, 94, 0.6)'}"></span>
					<span class="legend-name">{item.username}</span>
					<span class="legend-score">{item.maxScore}</span>
				</button>
			{/each}
		</div>
	</div>

	<div class="charts-grid">
		<div class="chart-card">
			<canvas bind:this={distributionCanvas}></canvas>
		</div>
		<div class="chart-card">
			<canvas bind:this={activityCanvas}></canvas>
		</div>
	</div>
</main>

<style>
	main {
		display: flex;
		flex-direction: column;
		gap: 1.5rem;
		max-width: 1100px;
		width: 100%;
		margin: 0 auto;
	}

	.page-header {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}

	.page-header h1 {
		margin: 0;
		font-size: 1.5rem;
		font-weight: 300;
		color: #e0e0e0;
	}

	.subtitle {
		font-size: 0.875rem;
		color: #666;
	}

	.stats-row {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
		gap: 1rem;
	}

	.stat-card {
		background: #1f1f1f;
		border: 1px solid #2a2a2a;
		border-radius: 10px;
		padding: 1rem 1.25rem;
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}

	.stat-card.positive {
		border-color: rgba(34, 197, 94, 0.3);
	}

	.stat-card.neutral {
		border-color: rgba(234, 179, 8, 0.3);
	}

	.stat-value {
		font-size: 1.75rem;
		font-weight: 400;
		color: #9cc1cf;
	}

	.stat-card.positive .stat-value {
		color: rgb(34, 197, 94);
	}

	.stat-card.neutral .stat-value {
		color: rgb(234, 179, 8);
	}

	.stat-label {
		font-size: 0.75rem;
		color: #666;
		text-transform: uppercase;
		letter-spacing: 0.5px;
	}

	.info-box {
		background: #1a1a1a;
		border: 1px solid #2a2a2a;
		border-radius: 8px;
		padding: 1rem;
		font-size: 0.875rem;
		color: #888;
	}

	.info-box strong {
		color: #9cc1cf;
	}

	.charts-grid {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
		gap: 1.5rem;
	}

	.chart-card {
		background: #1a1a1a;
		border: 1px solid #2a2a2a;
		border-radius: 12px;
		padding: 1.5rem;
		height: 350px;
	}

	.chart-full {
		height: 600px;
		flex: 1;
		min-width: 0;
	}

	.trajectory-container {
		display: flex;
		gap: 1rem;
	}

	.custom-legend {
		width: 220px;
		flex-shrink: 0;
		background: #1a1a1a;
		border: 1px solid #2a2a2a;
		border-radius: 12px;
		padding: 1rem;
		max-height: 600px;
		overflow-y: auto;
		overflow-x: hidden;
	}

	.custom-legend h3 {
		margin: 0 0 0.75rem 0;
		font-size: 0.85rem;
		font-weight: 500;
		color: #9cc1cf;
		text-transform: uppercase;
		letter-spacing: 0.5px;
	}

	.legend-item {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		width: 100%;
		padding: 0.4rem 0.5rem;
		background: transparent;
		border: none;
		border-radius: 4px;
		cursor: pointer;
		text-align: left;
		transition: background 0.1s;
	}

	.legend-item:hover,
	.legend-item.highlighted {
		background: #2a2a2a;
	}

	.legend-color {
		width: 16px;
		height: 3px;
		border-radius: 2px;
		flex-shrink: 0;
	}

	.legend-name {
		flex: 1;
		font-size: 0.8rem;
		color: #e0e0e0;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.legend-score {
		font-size: 0.75rem;
		font-weight: 600;
		color: #22c55e;
		min-width: 1.5rem;
		text-align: right;
	}

	.leaderboard {
		background: #1a1a1a;
		border: 1px solid #2a2a2a;
		border-radius: 12px;
		overflow: hidden;
	}

	.leaderboard h2 {
		margin: 0;
		padding: 1rem 1.5rem;
		font-size: 1rem;
		font-weight: 400;
		color: #e0e0e0;
		background: #1f1f1f;
		border-bottom: 1px solid #2a2a2a;
	}

	.table-wrapper {
		overflow-x: auto;
	}

	table {
		width: 100%;
		border-collapse: collapse;
	}

	th,
	td {
		padding: 0.75rem 1rem;
		text-align: left;
		border-bottom: 1px solid #2a2a2a;
	}

	th {
		font-size: 0.75rem;
		font-weight: 500;
		color: #666;
		text-transform: uppercase;
		letter-spacing: 0.5px;
		background: #1f1f1f;
	}

	td {
		font-size: 0.875rem;
		color: #e0e0e0;
	}

	tbody tr:hover {
		background: #252525;
	}

	.rank {
		color: #666;
		font-weight: 500;
	}

	.username {
		font-weight: 500;
	}

	.score {
		font-weight: 600;
	}

	.score.positive {
		color: rgb(34, 197, 94);
	}

	.score.zero {
		color: rgb(234, 179, 8);
	}

	.consecutive {
		color: rgb(34, 197, 94);
	}

	.missed {
		color: rgb(239, 68, 68);
	}

	@media (max-width: 900px) {
		.trajectory-container {
			flex-direction: column;
		}

		.custom-legend {
			width: 100%;
			max-height: 200px;
			display: flex;
			flex-wrap: wrap;
			gap: 0.25rem;
		}

		.custom-legend h3 {
			width: 100%;
		}

		.legend-item {
			width: auto;
			padding: 0.25rem 0.5rem;
		}
	}

	@media (max-width: 768px) {
		.charts-grid {
			grid-template-columns: 1fr;
		}

		.chart-card {
			min-width: 0;
			height: 300px;
		}

		.chart-full {
			height: 400px;
		}

		.stats-row {
			grid-template-columns: repeat(2, 1fr);
		}

		th,
		td {
			padding: 0.5rem 0.75rem;
		}
	}
</style>
