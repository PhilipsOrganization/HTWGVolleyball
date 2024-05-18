<script>
	import { Column, Container, Head, Html, Link, Preview, Section, Text } from 'svelte-email';

	/**
	 * @type {import("$lib/db/schema").Account}
	 */
	export let user;

	/**
	 * @type {import("$lib/db/schema").Course}
	 */
	export let course;

    /**
     * @type {import("$lib/db/schema").Account}
     */
    export let admin;

	const fontFamily = '-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif';
	const main = { backgroundColor: '#fff' };

	const container = {
		margin: '0 auto',
		padding: '20px 0 48px',
		width: '580px'
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
	<Preview preview={'You have received a strike :('} />
	<Section style={main}>
		<Container style={container}>
			<Text style={heading}>Hello, {user.username}!</Text>
			<Text style={paragraph}>You have signed up for a course today:</Text>
			<Section style={box}>
				<Text style={{ ...heading, fontSize: '22px' }}>{course.name}</Text>
				<Text style={paragraph}>Time: {course.time}</Text>
				<Text style={paragraph}>Location: {course.location}</Text>
			</Section>

            <Text style={paragraph}>You have received a strike for not showing up to the course.</Text>
            <Text style={paragraph}>Number of Strikes: {user.strikes}</Text>
            <Text style={paragraph}>If you have any questions, please contact {admin.username}.</Text>
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
