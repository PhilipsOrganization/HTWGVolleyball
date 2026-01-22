<script>
	import { format } from 'date-fns';
	import { Container, Head, Hr, Html, Section, Text, Preview, Link, Column } from 'svelte-email';

	

	
	/**
	 * @typedef {Object} Props
	 * @property {import("$lib/db/schema").Account} user
	 * @property {import("$lib/db/schema").Course} course
	 */

	/** @type {Props} */
	let { user, course } = $props();

	const date = format(new Date(course.date), 'EEEE, MMMM do, yyyy');
	const fontFamily = '-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif';
	const main = { backgroundColor: '#fff' };

	const container = {
		margin: '0 auto',
		padding: '20px 0 48px',
		width: '580px'
	};

	const button = {
		fontFamily,
		padding: '12px',
		backgroundColor: '#9cc1cf',
		borderRadius: '3px',
		color: '#000',
		fontSize: '18px',
		textDecoration: 'none',
		textAlign: 'center',
		display: 'block',
		width: '90%'
	};

	const paragraph = {
		fontFamily,
		fontSize: '18px',
		lineHeight: '1.4',
		color: '#484848'
	};

	const heading = {
		fontFamily,
		fontSize: '32px',
		lineHeight: '1.3',
		fontWeight: '700',
		color: '#484848'
	};

	const box = {
		borderStyle: 'solid',
		borderColor: 'gray',
		borderWidth: '1px 1px 1px 1px',
		padding: '16px 10% 20px'
	};
</script>

<Html lang="en">
	<Head />
	<Preview preview={'Course Signup Notification'} />
	<Section style={main}>
		<Container style={container}>
			<Text style={heading}>Hello, {user.username}!</Text>
			<Text style={paragraph}>A spot opened up for you!</Text>
			<Section style={box}>
				<Text style={{ ...heading, fontSize: '22px' }}>{course.name}</Text>
				<Text style={paragraph}>Date: {date}</Text>
				<Text style={paragraph}>Time: {course.time}</Text>
				<Text style={paragraph}>Location: {course.location}</Text>

				<Link style={button} href="https://volleyball.oesterlin.dev/course/{course.id}">View Course</Link>
			</Section>
		</Container>
	</Section>

	<Section style={main}>
		<Container style={container}>
			<Column>
				<Link href="https://volleyball.oesterlin.dev/courses">View Courses</Link>
			</Column>
			<Column>
				<Link href="https://volleyball.oesterlin.dev/profile">View Profile</Link>
			</Column>
			<Column>
				<Link href="https://volleyball.oesterlin.dev/profile">Unsubscribe</Link>
			</Column>
		</Container>
	</Section>
</Html>
