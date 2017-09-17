
if( typeof module !== 'undefined' )
{
  require( 'wTools' );
  /* require( 'wConsequence' ); */
  require( '../staging/dwtools/abase/syn/Consequence.s' );
}

/* correspondents */

function gotHandler1( error, value )
{
  console.log( 'handler 1 : ' + value );
  value++;
  return value;
}

function gotHandler2( error, value )
{
  debugger;
  console.log( 'handler 2 : ' + value );
  value++;
  return value;
}

function gotHandler3( error, value )
{
  console.log( 'handler 3 err : ' + error );
  console.log( 'handler 3 val : ' + value );
  value++;
  return value;
}

/* cases */

console.log( 'case 1' );

var con1 = new wConsequence();

con1.ifErrorThen( gotHandler3 ).got( gotHandler1 ).got( gotHandler2 );
con1.give( 1 ).give( 4 );
console.log( con1.toStr() );

/**/

console.log( 'case 2' );

var con1 = new wConsequence();

con1.give( 1 ).give( 4 );
con1.ifErrorThen( gotHandler3 ).got( gotHandler1 ).got( gotHandler2 );
console.log( con1.toStr() );

/**/

console.log( 'case 3' );
var con1 = new wConsequence();

con1.error( 'error msg' ).give( 14 );

con1.ifErrorThen( gotHandler3 ).got( gotHandler1 );
console.log( con1.toStr() );
