#let range(start, end) = {
  let ret = ()
  let i = start
  while i < end {
    ret.push(i)
    i = i + 1
  }
  ret
}

#let zip(..lists) = {
  let lists = lists.pos()
  if lists == () {
    ()
  } else {
    let ret = ()
    let len = lists.fold(
      lists.first().len(), 
      (a, b) => if a > b.len() { b.len() } else { a }
    )

    for i in range(0, len) {
      let curr = ()
      for list in lists {
        curr.push(list.at(i))
      }
      ret.push(curr)
    }

    ret
  }
}
