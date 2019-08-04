const fs = require('fs');
eval(fs.readFileSync('path.js').toString());

const path = require('path');

if (path.join('/file/', '..')
    !==
    join('/file/', '..')) {
  console.log('error');
}

if (path.join('/foo/bar/', '..')
    !==
    join('/foo/bar/', '..')) {
  console.log('error');
}

if (path.join('/file/', '.')
    !==
    join('/file/', '.')) {
  console.log('error');
}

if (path.normalize('/foo//./bar/.')
    !==
    normalize('/foo//./bar/.')) {
  console.log('error');
}
