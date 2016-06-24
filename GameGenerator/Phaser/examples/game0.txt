-- Literal ASP

resource(r1).
initialize(set(r1, low)).

precondition(le(r1, med), o1).
result(o1, increase(r1, low)).

-- Cygnus abstract syntax

[
  Resource("r1"),
  Initial("r1", Low),
  Outcome([RCond("r1", Less, Med)], [Increase("r1", Low)])
]

-- Phaser abstract syntax

{
  setup = {};
  create = {vars = [Resource("r1", low)]; sprites={}; buttons={} };
  update = {functions = {}; outcomes=[(if(lt(r1, med), assign(r1, add(r1,
  low))))]}; 
  render = {}
}

-- Literal Phaser code

low = 1;
med = 10;
hi = 100;
function setup { 
};

function create {
  var r1 = low;  
}

function update {
  if(r1 <= med) {
    r1 = r1 + low;
  }
}

function render {

}
