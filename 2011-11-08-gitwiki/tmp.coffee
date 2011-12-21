options =
  foo: 10
  bar: 20

result = {}
for k, v of options
  result[k] = v
console.log result

result2 = {}
result2[k] = v for k,v of options
console.log result2