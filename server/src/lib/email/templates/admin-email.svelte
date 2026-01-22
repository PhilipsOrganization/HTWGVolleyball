<script>
	import { Container, Head, Hr, Html, Section, Text, Preview, Link, Column } from 'svelte-email';

	
	
    

	

    
	/**
	 * @typedef {Object} Props
	 * @property {import("$lib/db/schema").Account} user
	 * @property {import("$lib/db/schema").Account} trainer
	 * @property {string} message
	 * @property {string} subject
	 */

	/** @type {Props} */
	let {
		user,
		trainer,
		message,
		subject
	} = $props();

	const fontFamily = '-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif';
	const main = { backgroundColor: '#fff' };

	const container = {
		margin: '0 auto',
		padding: '20px 0 48px',
		width: '580px'
	};

	const paragraph = {
		fontFamily,
		fontSize: '16px',
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
	<Preview preview={'You have received a message from your trainer!'} />
	<Section style={main}>
		<Container style={container}>
			<Text style={heading}>Hello, {user.username}!</Text>
			<Text style={paragraph}>You have received the following message from your volleyball trainer {trainer.username}:</Text>
			<Section style={box}>
                <Text style={{...paragraph, fontWeight: '600'}}>{subject}</Text>
                <Hr />
				<Text style={paragraph}>{@html message}</Text>
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
		</Container>
	</Section>
</Html>
