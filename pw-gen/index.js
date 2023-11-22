import { hash } from 'bcrypt';


// hash the password from the command line
console.log(process.argv[2]);
hash(process.argv[2].trim(), 10).then(console.log);