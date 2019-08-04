function join(path1, path2) {
  let result = path1;
  result += '/' + path2;
  return normalize(result);
}

function normalize(path) {
  let result = '';
  while (path.indexOf('//') !== -1) {
    path = path.replace('//', '/');
  }
  let splitted = path.split('/');
    // Debug!
    if (false) {
      console.log(JSON.stringify(splitted));
    }
    // Debug end.
  while (splitted.length > 0) {
    let shifted = splitted.shift();
    if (shifted === '') {
      result += '/';
    } else if (shifted === '.') {
    } else if (shifted === '..') {
      result = result.replace(/\/[^/]+$/, '/');
      if (result !== '/') {
        result = result.slice(0, result.length - 1);
      }
    } else {
      result += (!result.endsWith('/') ? ('/' + shifted) : shifted);
    }
  }
  return result;
}
