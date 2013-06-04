window.teas = [
  {name: "white", title: "White tea", temp: "65 - 70", time: 90},
  {name: "yellow", title: "Yellow tea", temp: "70 - 75", time: 90},
  {name: "green", title: "Green tea", temp: "75 - 80", time: 90},
  {name: "oolong", title: "Oolong tea", temp: "80 - 85", time: 150},
  {name: "black", title: "Black tea", temp: "99", time: 150},
  {name: "herbal", title: "Herbal tea", temp: "99", time: 300},
  {name: "fruit", title: "Fruit tea", temp: "99", time: 480}
]

window.degrees = [
  {name: "celsius", title: "Celsius", symbol: "C", formula: (val) -> return val},
  {name: "fahrenheit", title: "Fahrenheit", symbol: "F", formula: (val) -> return val*9/5+32},
  {name: "kelvin", title: "Kelvin", symbol: "K", formula: (val) -> return val+273.15},
  {name: "reaumur", title: "Réaumur", symbol: "Ré", formula: (val) -> return val*4/5},
  {name: "rankine", title: "Rankine", symbol: "R", formula: (val) -> return (val+273.15)*9/5},
  {name: "delisle", title: "Delisle", symbol: "De", formula: (val) -> return (100-val)*3/2},
  {name: "romer", title: "Rømer", symbol: "Rø", formula: (val) -> return val*21/40+7.5}
]

window.notificationTemplate = {title: "Tea clock", body: "Your tea is ready!" }