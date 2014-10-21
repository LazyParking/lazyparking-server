module.exports = {
  user: process.env.MONGODB_USER || '',
  pass: process.env.MONGODB_PASS || '',
  server: process.env.MONGODB_SERVER || 'localhost',
  port: process.env.MONGODB_PORT || 27017,
  name: process.env.MONGODB_NAME || 'lazypark'
};
