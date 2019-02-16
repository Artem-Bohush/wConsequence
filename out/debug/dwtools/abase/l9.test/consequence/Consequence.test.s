( function _Consequence_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  var _ = require( '../../../Tools.s' );

  // debugger;
  require( '../../l9/consequence/Consequence.s' );
  // debugger;
  _.include( 'wTesting' );
  // debugger;

}

var _global = _global_;
var _ = _global_.wTools;

// --
// test
// --

function trivial( test )
{
  var self = this;

  test.case = 'class checks'; /* */

  test.is( _.routineIs( wConsequence.prototype.FinallyPass ) );
  test.is( _.routineIs( wConsequence.FinallyPass ) );
  test.is( _.objectIs( wConsequence.prototype.KindOfResource ) );
  test.is( _.objectIs( wConsequence.KindOfResource ) );
  test.is( wConsequence.name === 'wConsequence' );
  test.is( wConsequence.shortName === 'Consequence' );

  test.case = 'construction'; /* */

  var con1 = new _.Consequence().take( 1 );
  var con2 = _.Consequence().take( 2 );
  var con3 = con2.clone();

  test.identical( con1.resourcesGet().length,1 );
  test.identical( con2.resourcesGet().length,1 );
  test.identical( con3.resourcesGet().length,1 );

  test.case = 'class test'; /* */

  test.is( _.consequenceIs( con1 ) );
  test.is( con1 instanceof wConsequence );
  test.is( _.consequenceIs( con2 ) );
  test.is( con2 instanceof wConsequence );
  test.is( _.consequenceIs( con3 ) );
  test.is( con3 instanceof wConsequence );

  con3.take( 3 );
  con3( 4 );
  con3( 5 );

  con3.got( ( err,arg ) => test.identical( arg,2 ) );
  con3.got( ( err,arg ) => test.identical( arg,3 ) );
  con3.got( ( err,arg ) => test.identical( arg,4 ) );
  con3.finally( ( err,arg ) => test.identical( con3.resourcesGet().length,0 ) );

  return con3;
}

//

function ordinarMessage( test )
{
  var c = this;
  var amode = _.Consequence.AsyncModeGet();

  test.case = 'give single resource';

  var que = new _.Consequence().take( null )

   /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 0 */

  .finally( () =>
  {
    _.Consequence.AsyncModeSet([ 0, 0 ]);
    test.open( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 0' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.take( 1 );
    test.identical( con.resourcesGet().length, 1 );
    con.got( function( err, got )
    {
      test.identical( err, undefined )
      test.identical( got, 1 );
    })
    test.identical( con.resourcesGet().length, 0 );
    test.identical( con.competitorsEarlyGet().length, 0 );
    return null;
  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 0 */

  .finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 0' );
    _.Consequence.AsyncModeSet([ 1, 0 ]);
    test.open( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 0' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.take( 1 );
    test.identical( con.resourcesGet().length, 1 );
    con.got( function( err, got )
    {
      test.identical( err, undefined )
      test.identical( got, 1 );
    })
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.competitorsEarlyGet().length, 1 );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 1 */

  .finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 0' );
    _.Consequence.AsyncModeSet([ 0, 1 ]);
    test.open( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 1' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.take( 1 );

    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 1 );
      test.identical( con.competitorsEarlyGet().length, 0 );

      con.got( function( err, got )
      {
        test.identical( err, undefined )
        test.identical( got, 1 );
      })
      return null;
    })
    .keep/*finally*/( function( arg )
    {
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 1 */

  .finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 1' );
    _.Consequence.AsyncModeSet([ 1, 1 ]);
    test.open( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 1' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.take( 1 );
    con.got( function( err, got )
    {
      test.identical( err, undefined )
      test.identical( got, 1 );
    })
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.competitorsEarlyGet().length, 1 );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      return null;
    })
  });

  test.case = 'give several resources';

  /* - AsyncCompetitorHanding : 0, AsyncResourceAdding : 0 - */

  que.finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 1' );
    _.Consequence.AsyncModeSet([ 0, 0 ]);
    test.open( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 0' );
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.take( 1 ).take( 2 ).take( 3 );
    test.identical( con.resourcesGet().length, 3 );
    con.got( ( err, got ) => test.identical( got, 1 ) );
    con.got( ( err, got ) => test.identical( got, 2 ) );
    con.got( ( err, got ) => test.identical( got, 3 ) );
    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 0 */

  .finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 0' );
    _.Consequence.AsyncModeSet([ 1, 0 ]);
    test.open( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 0' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.take( 1 ).take( 2 ).take( 3 );
    con.got( ( err, got ) => test.identical( got, 1 ) );
    con.got( ( err, got ) => test.identical( got, 2 ) );
    con.got( ( err, got ) => test.identical( got, 3 ) );
    test.identical( con.competitorsEarlyGet().length, 3 );
    test.identical( con.resourcesGet().length, 3 );
    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 1 */

  .finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 0' );
    _.Consequence.AsyncModeSet([ 0, 1 ]);
    test.open( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 1' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.take( 1 ).take( 2 ).take( 3 );

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 3 );

      con.got( ( err, got ) => test.identical( got, 1 ) );
      con.got( ( err, got ) => test.identical( got, 2 ) );
      con.got( ( err, got ) => test.identical( got, 3 ) );
      return null;
    })
    .keep/*finally*/( function( arg )
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })

  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 1 */

  .finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 1' );
    _.Consequence.AsyncModeSet([ 1, 1 ]);
    test.open( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 1' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.take( 1 ).take( 2 ).take( 3 );
    con.got( ( err, got ) => test.identical( got, 1 ) );
    con.got( ( err, got ) => test.identical( got, 2 ) );
    con.got( ( err, got ) => test.identical( got, 3 ) );
    test.identical( con.competitorsEarlyGet().length, 3 );
    test.identical( con.resourcesGet().length, 3 );
    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  });

  test.case = 'give single error';

  /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 0 */

  que.finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 1' );
    _.Consequence.AsyncModeSet([ 0, 0 ]);
    test.open( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 0' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.error( 'err' );
    test.identical( con.resourcesGet().length, 1 );
    con.got( function( err, got )
    {
      test.identical( err, 'err' )
      test.identical( got, undefined );
    })
    test.identical( con.resourcesGet().length, 0 );
    test.identical( con.competitorsEarlyGet().length, 0 );
    return null;
  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 0 */

  .finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 0' );
    _.Consequence.AsyncModeSet([ 1, 0 ]);
    test.open( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 0' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.error( 'err' );
    test.identical( con.resourcesGet().length, 1 );
    con.got( function( err, got )
    {
      test.identical( err, 'err' )
      test.identical( got, undefined );
    })
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.competitorsEarlyGet().length, 1 );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 1 */

  .finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 0' );
    _.Consequence.AsyncModeSet([ 0, 1 ]);
    test.open( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 1' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.error( 'err' );

    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 1 );
      test.identical( con.competitorsEarlyGet().length, 0 );

      con.got( function( err, got )
      {
        test.identical( err, 'err' )
        test.identical( got, undefined );
      })
      return null;
    })
    .keep/*finally*/( function( arg )
    {
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 1 */

  .finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 1' );
    _.Consequence.AsyncModeSet([ 1, 1 ]);
    test.open( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 1' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.error( 'err' );
    con.got( function( err, got )
    {
      test.identical( err, 'err' )
      test.identical( got, undefined );
    })
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.competitorsEarlyGet().length, 1 );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      return null;
    })
  });

  test.case = 'give several error resources';

  /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 0 */

  que.finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 1' );
    _.Consequence.AsyncModeSet([ 0, 0 ]);
    test.open( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 0' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.error( 'err1' ).error( 'err2' ).error( 'err3' );
    test.identical( con.resourcesGet().length, 3 );
    con.got( ( err, got ) => test.identical( err, 'err1' ) );
    con.got( ( err, got ) => test.identical( err, 'err2' ) );
    con.got( ( err, got ) => test.identical( err, 'err3' ) );
    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 0 */

  .finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 0' );
    _.Consequence.AsyncModeSet([ 1, 0 ]);
    test.open( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 0' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.error( 'err1' ).error( 'err2' ).error( 'err3' );
    con.got( ( err, got ) => test.identical( err, 'err1' ) );
    con.got( ( err, got ) => test.identical( err, 'err2' ) );
    con.got( ( err, got ) => test.identical( err, 'err3' ) );
    test.identical( con.competitorsEarlyGet().length, 3 );
    test.identical( con.resourcesGet().length, 3 );
    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 1 */

  .finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 0' );
    _.Consequence.AsyncModeSet([ 0, 1 ]);
    test.open( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 1' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.error( 'err1' ).error( 'err2' ).error( 'err3' );

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 3 );

      con.got( ( err, got ) => test.identical( err, 'err1' ) );
      con.got( ( err, got ) => test.identical( err, 'err2' ) );
      con.got( ( err, got ) => test.identical( err, 'err3' ) );
      return null;
    })
    .keep/*finally*/( function( arg )
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 1 */

  .finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 1' );
    _.Consequence.AsyncModeSet([ 1, 1 ]);
    test.open( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 1' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.error( 'err1' ).error( 'err2' ).error( 'err3' );
    con.got( ( err, got ) => test.identical( err, 'err1' ) );
    con.got( ( err, got ) => test.identical( err, 'err2' ) );
    con.got( ( err, got ) => test.identical( err, 'err3' ) );
    test.identical( con.competitorsEarlyGet().length, 3 );
    test.identical( con.resourcesGet().length, 3 );
    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  });

  /* */

  que.finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 1' );
    _.Consequence.AsyncModeSet( amode );
    return null;
  })
  return que;
}

//

function finallyPromiseGive( test )
{
  var testMsg = 'testMsg';
  var que = new _.Consequence().take( null )

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'no resource';
    var con = new _.Consequence();
    var promise = con.finallyPromiseGive();
    test.identical( con.resourcesGet().length, 0 );
    test.identical( con.competitorsEarlyGet().length, 1 );
    promise.then( function( got )
    {
      test.identical( 0, 1 );
    });

    return _.timeOut( 10, function()
    {
      debugger;
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 1 );
      con.competitorsCancel();
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
    });

  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'single resource';
    var con = new _.Consequence();
    con.take( testMsg );
    test.identical( con.resourcesGet().length, 1 );
    // debugger;
    var promise = con.finallyPromiseGive();
    // debugger;
    promise.then( function( got )
    {
      test.identical( got, testMsg );
      test.is( _.promiseIs( promise ) );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      // debugger;
    })
    // debugger;
    let result = _.Consequence.From( promise );
    // debugger;
    return result;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'single error';
    var con = new _.Consequence();
    con.error( testMsg );

    test.identical( con.resourcesCount(), 1 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.errorsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );

    var promise = con.finallyPromiseGive();

    test.identical( con.resourcesCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.errorsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );

    promise.catch( function( err )
    {
      test.identical( err, testMsg );
      test.is( _.promiseIs( promise ) );
      test.identical( con.resourcesCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
    });

    return _.Consequence.From( promise ).finally( () => null );
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'several resources';
    var con = new _.Consequence();
    con.take( testMsg  + 1 );
    con.take( testMsg  + 2 );
    con.take( testMsg  + 3 );
    test.identical( con.resourcesGet().length, 3 );
    var promise = con.finallyPromiseGive();
    promise.then( function( got )
    {
      test.identical( got, testMsg + 1 );
      test.is( _.promiseIs( promise ) );
      test.identical( con.resourcesGet().length, 2 );
      test.identical( con.competitorsEarlyGet().length, 0 );
    })
    return _.Consequence.From( promise );
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    wConsequence.prototype.AsyncResourceAdding = 1;
    wConsequence.prototype.AsyncCompetitorHanding = 0;
    return null;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async resources adding, single resource';
    var con = new _.Consequence();
    var promise = con.finallyPromiseGive();
    con.take( testMsg );
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 1 );
    return _.timeOut( 1, function()
    {
      promise.then( function( got )
      {
        test.identical( got, testMsg );
        test.is( _.promiseIs( promise ) );
        test.identical( con.resourcesGet().length, 0 );
        test.identical( con.competitorsEarlyGet().length, 0 );
      });
      return _.Consequence.From( promise );
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async resources adding, single error';
    var con = new _.Consequence();
    var promise = con.finallyPromiseGive();
    con.error( testMsg );
    promise.catch( function( err )
    {
      test.identical( err, testMsg );
      test.is( _.promiseIs( promise ) );
    });
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.competitorsEarlyGet().length, 1 );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      return _.Consequence.From( promise ).finally( () => null );
    });
  })


  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async resources adding, several resources';
    var con = new _.Consequence();
    var promise = con.finallyPromiseGive();
    con.take( testMsg  + 1 );
    con.take( testMsg  + 2 );
    con.take( testMsg  + 3 );
    test.identical( con.resourcesGet().length, 3 );
    test.identical( con.competitorsEarlyGet().length, 1 );

    return _.timeOut( 1, function()
    {
      promise.then( function( got )
      {
        test.identical( got, testMsg + 1 );
        test.is( _.promiseIs( promise ) );
        test.identical( con.resourcesGet().length, 2 );
        test.identical( con.competitorsEarlyGet().length, 0 );
      })
      return _.Consequence.From( promise );
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    wConsequence.prototype.AsyncResourceAdding = 0;
    wConsequence.prototype.AsyncCompetitorHanding = 1;
    return null;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding, single resource';
    var con = new _.Consequence();
    con.take( testMsg );
    var promise = con.finallyPromiseGive();
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 1 );
    return _.timeOut( 1, function()
    {
      promise.then( function( got )
      {
        test.identical( got, testMsg );
        test.is( _.promiseIs( promise ) );
        test.identical( con.resourcesGet().length, 0 );
        test.identical( con.competitorsEarlyGet().length, 0 );
      });
      return _.Consequence.From( promise );
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding, error resource';
    var con = new _.Consequence();
    con.error( testMsg );
    var promise = con.finallyPromiseGive();
    promise.catch( function( err )
    {
      test.identical( err, testMsg );
      test.is( _.promiseIs( promise ) );
    });
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.competitorsEarlyGet().length, 1 );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      return _.Consequence.From( promise ).finally( () => null );
    });
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding, several resources';
    var con = new _.Consequence();
    con.take( testMsg  + 1 );
    con.take( testMsg  + 2 );
    con.take( testMsg  + 3 );
    var promise = con.finallyPromiseGive();
    test.identical( con.resourcesGet().length, 3 );
    test.identical( con.competitorsEarlyGet().length, 1 );

    return _.timeOut( 1, function()
    {
      promise.then( function( got )
      {
        test.identical( got, testMsg + 1 );
        test.is( _.promiseIs( promise ) );
        test.identical( con.resourcesGet().length, 2 );
        test.identical( con.competitorsEarlyGet().length, 0 );
      })
      return _.Consequence.From( promise );
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    wConsequence.prototype.AsyncResourceAdding = 1;
    wConsequence.prototype.AsyncCompetitorHanding = 1;
    return null;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding+resources adding signle resource';
    var con = new _.Consequence();
    con.take( testMsg );
    var promise = con.finallyPromiseGive();
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 1 );
    return _.timeOut( 1, function()
    {
      promise.then( function( got )
      {
        test.identical( got, testMsg );
        test.is( _.promiseIs( promise ) );
        test.identical( con.resourcesGet().length, 0 );
        test.identical( con.competitorsEarlyGet().length, 0 );
      });
      return _.Consequence.From( promise );
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding+resources adding error resource';
    var con = new _.Consequence();
    con.error( testMsg );
    var promise = con.finallyPromiseGive();
    promise.catch( function( err )
    {
      test.identical( err, testMsg );
      test.is( _.promiseIs( promise ) );
    });
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.competitorsEarlyGet().length, 1 );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      return _.Consequence.From( promise ).finally( () => null );
    });
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding+resources adding several resources';
    var con = new _.Consequence();
    con.take( testMsg  + 1 );
    con.take( testMsg  + 2 );
    con.take( testMsg  + 3 );
    var promise = con.finallyPromiseGive();
    test.identical( con.resourcesGet().length, 3 );
    test.identical( con.competitorsEarlyGet().length, 1 );

    return _.timeOut( 1, function()
    {
      promise.then( function( got )
      {
        test.identical( got, testMsg + 1 );
        test.is( _.promiseIs( promise ) );
        test.identical( con.resourcesGet().length, 2 );
        test.identical( con.competitorsEarlyGet().length, 0 );
      })
      return _.Consequence.From( promise );
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    wConsequence.prototype.AsyncResourceAdding = 0;
    wConsequence.prototype.AsyncCompetitorHanding = 0;
    return null;
  })

  return que;
}

finallyPromiseGive.timeOut = 13000;

//

function _finally( test )
{
  var c = this;
  var amode = _.Consequence.AsyncModeGet();
  var testMsg = 'msg';
  var con;
  var que = new _.Consequence().take( null )

  .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 0, 0 ]);
    test.case += ', no resource'
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    con = new _.Consequence();
    con.finally( () => test.identical( 0, 1 ) );
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })
  .timeOut( 100 )
  .keep/*finally*/( function( arg )
  {
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 );
    con.competitorsCancel();
    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 1, 0 ]);
    test.case += ', no resource'
    return null;
  })

  // .keep/*finally*/( function( arg )
  // {
  //   var con = new _.Consequence();
  //   con.finally( () => test.identical( 0, 1 ) );
  //   test.identical( con.competitorsEarlyGet().length, 1 );
  //   test.identical( con.resourcesGet().length, 0 );ччч
  //   return null;
  // })

  .keep/*finally*/( function( arg )
  {
    con = new _.Consequence();
    con.finally( () => test.identical( 0, 1 ) );
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })
  .timeOut( 100 )
  .keep/*finally*/( function( arg )
  {
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 );
    con.competitorsCancel();
    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 0, 1 ]);
    test.case += ', no resource'
    return null;
  })
  // .keep/*finally*/( function( arg )
  // {
  //   var con = new _.Consequence();
  //   con.finally( () => test.identical( 0, 1 ) );
  //   test.identical( con.competitorsEarlyGet().length, 1 );
  //   test.identical( con.resourcesGet().length, 0 );
  //   return null;
  // })

  .keep/*finally*/( function( arg )
  {
    con = new _.Consequence();
    con.finally( () => test.identical( 0, 1 ) );
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })
  .timeOut( 100 )
  .keep/*finally*/( function( arg )
  {
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 );
    con.competitorsCancel();
    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 1, 1 ]);
    test.case += ', no resource'
    return null;
  })
  // .keep/*finally*/( function( arg )
  // {
  //   var con = new _.Consequence();
  //   con.finally( () => test.identical( 0, 1 ) );
  //   test.identical( con.competitorsEarlyGet().length, 1 );
  //   test.identical( con.resourcesGet().length, 0 );
  //   return null;
  // })

  .keep/*finally*/( function( arg )
  {
    con = new _.Consequence();
    con.finally( () => test.identical( 0, 1 ) );
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })
  .timeOut( 100 )
  .keep/*finally*/( function( arg )
  {
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 );
    con.competitorsCancel();
    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })

   /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 0 */

  .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 0, 0 ]);
    test.case += ', single resource, competitor is a routine'
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    function competitor( err, got )
    {
      test.identical( err , undefined )
      test.identical( got , testMsg );
      return null;
    }
    var con = new _.Consequence();
    con.take( testMsg );
    test.identical( con.resourcesGet().length, 1 )
    test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : testMsg } )
    con.finally( competitor );
    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 1 )
    test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : null } );

    return con;
  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 0 */

  .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 1, 0 ]);
    test.case += ', single resource, competitor is a routine'
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    function competitor( err, got )
    {
      test.identical( err , undefined )
      test.identical( got , testMsg );
      return null;
    }
    var con = new _.Consequence();
    con.take( testMsg );
    con.finally( competitor );
    test.identical( con.resourcesGet().length, 1 )
    test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : testMsg } )
    test.identical( con.competitorsEarlyGet().length, 1 );

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 1 )
      test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : null } )
    })
  })

  /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 1 */

  .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 0, 1 ]);
    test.case += ', single resource, competitor is a routine'
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    function competitor( err, got )
    {
      test.identical( err , undefined )
      test.identical( got , testMsg );
      return null;
    }
    var con = new _.Consequence();
    con.take( testMsg );

    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 1 )
      test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : testMsg } )
      test.identical( con.competitorsEarlyGet().length, 0 );

      con.finally( competitor );
      return null;
    })
    .keep/*finally*/( function( arg )
    {
      test.identical( con.competitorsEarlyGet().length, 0 )
      test.identical( con.resourcesGet().length, 1 )
      test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : null } )
      return null;
    })
  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 1 */

   .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 1, 1 ]);
    test.case += ', single resource, competitor is a routine'
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    function competitor( err, got )
    {
      test.identical( err , undefined )
      test.identical( got , testMsg );
      return null;
    }
    var con = new _.Consequence();
    con.take( testMsg );
    con.finally( competitor );
    test.identical( con.competitorsEarlyGet().length, 1 )
    test.identical( con.resourcesGet().length, 1 )
    test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : testMsg } )
    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 )
      test.identical( con.resourcesGet().length, 1 )
      test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : null } )
      return null;
    })

  })

  /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 0 */

   .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 0, 0 ]);
    test.case += ', several finally, competitor is a routine';
    return null;
  })
  .keep/*finally*/( function( arg )
  {

    var con = new _.Consequence();
    con.take( testMsg );
    con.finally( function( err, got )
    {
      test.identical( err , undefined )
      test.identical( got , testMsg );
      return testMsg + 1;
    });
    con.finally( function( err, got )
    {
      test.identical( err , undefined )
      test.identical( got , testMsg + 1);
      return testMsg + 2;
    });
    con.finally( function( err, got )
    {
      test.identical( err , undefined )
      test.identical( got , testMsg + 2);
      return testMsg + 3;
    });
    test.identical( con.competitorsEarlyGet().length, 0 )
    test.identical( con.resourcesGet().length, 1 )
    test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : testMsg + 3 } );

    return con;
  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 0 */

   .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 1, 0 ]);
    test.case += ', several finally, competitor is a routine';
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.take( testMsg );
    con.finally( function( err, got )
    {
      test.identical( err , undefined )
      test.identical( got , testMsg );
      return testMsg + 1;
    });
    con.finally( function( err, got )
    {
      test.identical( err , undefined )
      test.identical( got , testMsg + 1);
      return testMsg + 2;
    });
    con.finally( function( err, got )
    {
      test.identical( err , undefined )
      test.identical( got , testMsg + 2);
      return testMsg + 3;
    });
    test.identical( con.competitorsEarlyGet().length, 3 )
    test.identical( con.resourcesGet().length, 1 )
    test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : testMsg } );

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 )
      test.identical( con.resourcesGet().length, 1 )
      test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : testMsg + 3 } );
      return null;
    })

  })

  /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 1 */

   .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 0, 1 ]);
    test.case += ', several finally, competitor is a routine';
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.take( testMsg );

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 )
      test.identical( con.resourcesGet().length, 1 )
      test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : testMsg } );

      con.finally( function( err, got )
      {
        test.identical( err , undefined )
        test.identical( got , testMsg );
        return testMsg + 1;
      });
      con.finally( function( err, got )
      {
        test.identical( err , undefined )
        test.identical( got , testMsg + 1);
        return testMsg + 2;
      });
      con.finally( function( err, got )
      {
        test.identical( err , undefined )
        test.identical( got , testMsg + 2);
        return testMsg + 3;
      });

      return con;
    })
    .keep/*finally*/( function( arg )
    {
      test.identical( con.competitorsEarlyGet().length, 0 )
      test.identical( con.resourcesGet().length, 1 )
      test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : testMsg + 3 } );
      return null;
    })

  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 1 */

   .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 1, 1 ]);
    test.case += ', several finally, competitor is a routine';
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    con.take( testMsg );

    con.finally( function( err, got )
    {
      test.identical( err , undefined )
      test.identical( got , testMsg );
      return testMsg + 1;
    });
    con.finally( function( err, got )
    {
      test.identical( err , undefined )
      test.identical( got , testMsg + 1);
      return testMsg + 2;
    });
    con.finally( function( err, got )
    {
      test.identical( err , undefined )
      test.identical( got , testMsg + 2);
      return testMsg + 3;
    });

    test.identical( con.competitorsEarlyGet().length, 3 );
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : testMsg } );

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 1 );
      test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : testMsg + 3} );
      return null;
    })

  })

   /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 0 */

   .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 0, 0 ]);
    test.case += ', single resource, consequence as a competitor';
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    var con2 = new _.Consequence();
    var con2TakerFired = false;
    con.take( testMsg );
    /* finally only transfers the copy of messsage to the competitor without waiting for response */
    con.finally( con2 );
    con.got( function( err, got )
    {
      test.identical( got, testMsg );
      test.identical( con2TakerFired, false );
      test.identical( con2.resourcesGet().length, 1 );
    });

    con2.finally( function( err, got )
    {
      test.identical( got, testMsg )
      con2TakerFired = true;
      return null;
    });

    con2.finally( function()
    {
      test.identical( con2TakerFired, true );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 0 );
      return null;
    });

    return con2;
  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 0 */

   .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 1, 0 ]);
    test.case += ', single resource, consequence as a competitor';
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    var con2 = new _.Consequence();
    var con2TakerFired = false;
    con.take( testMsg );
    con.finally( con2 );
    con.got( function( err, got )
    {
      test.identical( got, testMsg );
      test.identical( con2TakerFired, true );
      test.identical( con2.resourcesGet().length, 0 );
    });

    con2.got( function( err, got )
    {
      test.identical( got, testMsg )
      con2TakerFired = true;
    });

    test.identical( con2TakerFired, false );
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.competitorsEarlyGet().length, 2 );
    test.identical( con2.competitorsEarlyGet().length, 1 );

    return _.timeOut( 1, function()
    {
      test.identical( con2TakerFired, true );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 0 );
      return null;
    })

  })

  /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 1 */

   .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 0, 1 ]);
    test.case += ', single resource, consequence as a competitor';
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    var con2 = new _.Consequence();
    var con2TakerFired = false;
    con.take( testMsg );

    test.identical( con2TakerFired, false );
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con2.competitorsEarlyGet().length, 0 );

    return _.timeOut( 1, function()
    {
      con.finally( con2 );
      con.got( function( err, arg )
      {
        test.identical( arg, testMsg );
        test.identical( con2TakerFired, false );
        test.identical( con2.resourcesGet().length, 1 );
      });

      con2.finally( function( err, arg )
      {
        test.identical( arg, testMsg );
        con2TakerFired = true;
        return arg;
      });

      return con2;
    })
    .keep/*finally*/( function( arg )
    {
      test.identical( con2TakerFired, true );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con2.resourcesGet().length, 1 );
      test.identical( con2.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 1 */

   .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 1, 1 ]);
    test.case += ', single resource, consequence as a competitor';
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    var con2 = new _.Consequence();
    var con2TakerFired = false;
    con.take( testMsg );
    con.finally( con2 );
    con.got( function( err, got )
    {
      test.identical( got, testMsg );
      test.identical( con2TakerFired, false );
      test.identical( con2.resourcesGet().length, 1 );
    });

    con2.got( function( err, got )
    {
      test.identical( got, testMsg );
      con2TakerFired = true;
    });

    test.identical( con2TakerFired, false );
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.competitorsEarlyGet().length, 2 );
    test.identical( con2.competitorsEarlyGet().length, 1 );
    test.identical( con2.resourcesGet().length, 0 );

    return _.timeOut( 1, function()
    {
      test.identical( con2TakerFired, true );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 0 */

   .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 0, 0 ]);
    test.case += 'competitor returns consequence with msg';
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    var con2 = new _.Consequence();
    con.take( null );
    con.finally( function()
    {
      return con2.take( testMsg );
    });

    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.resourcesGet()[ 0 ].argument, testMsg );

    test.identical( con2.resourcesGet().length, 1 );
    test.identical( con2.resourcesGet()[ 0 ].argument, testMsg );

    return null;

  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 0 */

   .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 1, 0 ]);
    test.case += 'competitor returns consequence with msg';
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    var con2 = new _.Consequence();
    con.take( null );
    con.finally( function()
    {
      return con2.take( testMsg );
    });

    test.identical( con.competitorsEarlyGet().length, 1 );

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 1 );
      test.identical( con.resourcesGet()[ 0 ].argument, testMsg );

      test.identical( con2.resourcesGet().length, 1 );
      test.identical( con2.resourcesGet()[ 0 ].argument, testMsg );
      return null;
    })
  })

  /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 1 */

   .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 0, 1 ]);
    test.case += 'competitor returns consequence with msg';
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    var con2 = new _.Consequence();
    con.take( null );

    test.identical( con.resourcesGet().length, 1 );

    return _.timeOut( 1, function()
    {
      con.finally( function()
      {
        return con2.take( testMsg );
      });

      return con;
    })
    .keep/*finally*/( function( arg )
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 1 );
      test.identical( con.resourcesGet()[ 0 ].argument, testMsg );

      test.identical( con2.resourcesGet().length, 1 );
      test.identical( con2.resourcesGet()[ 0 ].argument, testMsg );
      return null;
    })
  })

  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 1 */

   .keep/*finally*/( function( arg )
  {
    _.Consequence.AsyncModeSet([ 1, 1 ]);
    test.case += 'competitor returns consequence with msg';
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    var con = new _.Consequence();
    var con2 = new _.Consequence();
    con.take( null );
    con.finally( function()
    {
      return con2.take( testMsg );
    });

    test.identical( con.resourcesGet().length, 1 );

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 1 );
      test.identical( con.resourcesGet()[ 0 ].argument, testMsg );

      test.identical( con2.resourcesGet().length, 1 );
      test.identical( con2.resourcesGet()[ 0 ].argument, testMsg );
      return null;
    })
  })

  /* */

  que.finally( ( err, arg ) =>
  {
    // test.close( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 1' );
    _.Consequence.AsyncModeSet( amode );
    if( err )
    throw err;
    return arg;
  });

  return que;
}

//

function finallyPromiseKeep( test )
{
  var testMsg = 'testMsg';
  var con;
  var que = new _.Consequence().take( null )

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'no resource';
    con = new _.Consequence();
    var promise = con.finallyPromiseKeep();
    test.identical( con.resourcesGet().length, 0 );
    test.identical( con.competitorsEarlyGet().length, 1 );
    promise.then( function( got )
    {
      test.identical( 0, 1 );
    })
    return _.timeOut( 10 );
  })

  .timeOut( 100 )
  .keep/*finally*/( function( arg )
  {
    test.identical( con.resourcesGet().length, 0 );
    test.identical( con.competitorsEarlyGet().length, 1 );
    con.competitorsCancel();
    test.identical( con.resourcesGet().length, 0 );
    test.identical( con.competitorsEarlyGet().length, 0 );
    return arg;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'single resource';
    var con = new _.Consequence();
    con.take( testMsg );
    test.identical( con.resourcesGet().length, 1 );
    var promise = con.finallyPromiseKeep();
    promise.then( function( got )
    {
      test.identical( got, testMsg );
      test.is( _.promiseIs( promise ) );
      test.identical( con.resourcesGet(), [{ error : undefined, argument : testMsg }] );
      test.identical( con.competitorsEarlyGet().length, 0 );
    })

    return _.Consequence.From( promise );
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'error resource';
    var con = new _.Consequence();
    con.error( testMsg );
    test.identical( con.resourcesGet().length, 1 );
    var promise = con.finallyPromiseKeep();
    promise.catch( function( err )
    {
      test.identical( err, testMsg );
      test.is( _.promiseIs( promise ) );
      test.identical( con.resourcesGet(), [{ error : testMsg, argument : undefined }] );
      test.identical( con.competitorsEarlyGet().length, 0 );
    })
    return _.Consequence.From( promise ).finally( () => null );
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'several resources';
    var con = new _.Consequence();
    con.take( testMsg  + 1 );
    con.take( testMsg  + 2 );
    con.take( testMsg  + 3 );
    test.identical( con.resourcesGet().length, 3 );
    var promise = con.finallyPromiseKeep();
    promise.then( function( got )
    {
      test.identical( got, testMsg + 1 );
      test.is( _.promiseIs( promise ) );
      test.identical( con.resourcesGet().length, 3 );
      test.identical( con.competitorsEarlyGet().length, 0 );
    })
    return _.Consequence.From( promise );
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    wConsequence.prototype.AsyncResourceAdding = 1;
    wConsequence.prototype.AsyncCompetitorHanding = 0;
    return arg;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async resources adding, single resource';
    var con = new _.Consequence();
    var promise = con.finallyPromiseKeep();
    con.take( testMsg );
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 1 );
    return _.timeOut( 1, function()
    {
      promise.then( function( got )
      {
        test.identical( got, testMsg );
        test.is( _.promiseIs( promise ) );
        test.identical( con.resourcesGet(), [{ error : undefined, argument : testMsg }] );
        test.identical( con.competitorsEarlyGet().length, 0 );
      });
      return _.Consequence.From( promise );
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async resources adding, error resource';
    var catched = 0;
    var con = new _.Consequence();
    var promise = con.finallyPromiseKeep();
    promise.catch( function( err )
    {
      test.identical( err, testMsg );
      test.is( _.promiseIs( promise ) );
      catched = 1;
    });
    con.error( testMsg );
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.competitorsEarlyGet().length, 1 );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet(), [{ error : testMsg, argument : undefined }] );
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( catched, 1 );
      return _.Consequence.From( promise ).finally( () => null );
    });
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async resources adding, several resources';
    var con = new _.Consequence();
    var promise = con.finallyPromiseKeep();
    con.take( testMsg  + 1 );
    con.take( testMsg  + 2 );
    con.take( testMsg  + 3 );
    test.identical( con.resourcesGet().length, 3 );
    test.identical( con.competitorsEarlyGet().length, 1 );

    return _.timeOut( 1, function()
    {
      promise.then( function( got )
      {
        test.identical( got, testMsg + 1 );
        test.is( _.promiseIs( promise ) );
        test.identical( con.resourcesGet().length, 3 );
        test.identical( con.competitorsEarlyGet().length, 0 );
      })
      return _.Consequence.From( promise );
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    wConsequence.prototype.AsyncResourceAdding = 0;
    wConsequence.prototype.AsyncCompetitorHanding = 1;
    return arg;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding, single resource';
    var con = new _.Consequence();
    con.take( testMsg );
    var promise = con.finallyPromiseKeep();
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 1 );
    return _.timeOut( 1, function()
    {
      promise.then( function( got )
      {
        test.identical( got, testMsg );
        test.is( _.promiseIs( promise ) );
        test.identical( con.resourcesGet(), [{ error : undefined, argument : testMsg }] );
        test.identical( con.competitorsEarlyGet().length, 0 );
      });
      return _.Consequence.From( promise );
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding, error resource';
    var con = new _.Consequence();
    var catched = 0;
    con.error( testMsg );
    var promise = con.finallyPromiseKeep();
    promise.catch( function( err )
    {
      catched = 1;
      test.identical( err, testMsg );
      test.is( _.promiseIs( promise ) );
    });
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.competitorsEarlyGet().length, 1 );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet(), [{ error : testMsg, argument : undefined }] );
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( catched, 1 );
      return _.Consequence.From( promise ).finally( () => null );
    });
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding, several resources';
    var con = new _.Consequence();
    con.take( testMsg  + 1 );
    con.take( testMsg  + 2 );
    con.take( testMsg  + 3 );
    var promise = con.finallyPromiseKeep();
    test.identical( con.resourcesGet().length, 3 );
    test.identical( con.competitorsEarlyGet().length, 1 );

    return _.timeOut( 1, function()
    {
      promise.then( function( got )
      {
        test.identical( got, testMsg + 1 );
        test.is( _.promiseIs( promise ) );
        test.identical( con.resourcesGet().length, 3 );
        test.identical( con.competitorsEarlyGet().length, 0 );
      })
      return _.Consequence.From( promise );
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    wConsequence.prototype.AsyncResourceAdding = 1;
    wConsequence.prototype.AsyncCompetitorHanding = 1;
    return arg;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding+resources adding, single resource';
    var con = new _.Consequence();
    con.take( testMsg );
    var promise = con.finallyPromiseKeep();
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 1 );
    return _.timeOut( 1, function()
    {
      promise.then( function( got )
      {
        test.identical( got, testMsg );
        test.is( _.promiseIs( promise ) );
        test.identical( con.resourcesGet(), [{ error : undefined, argument : testMsg }] );
        test.identical( con.competitorsEarlyGet().length, 0 );
      });
      return _.Consequence.From( promise );
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding+resources adding, error resource';
    var catched = 0;
    var con = new _.Consequence();
    con.error( testMsg );
    var promise = con.finallyPromiseKeep();
    promise.catch( function( err )
    {
      test.identical( err, testMsg );
      test.is( _.promiseIs( promise ) );
      catched = 1;
    });
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.competitorsEarlyGet().length, 1 );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet(), [{ error : testMsg, argument : undefined }] );
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( catched, 1 );
      return _.Consequence.From( promise ).finally( () => null );
    });
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding+resources adding, several resources';
    var con = new _.Consequence();
    con.take( testMsg  + 1 );
    con.take( testMsg  + 2 );
    con.take( testMsg  + 3 );
    var promise = con.finallyPromiseKeep();
    test.identical( con.resourcesGet().length, 3 );
    test.identical( con.competitorsEarlyGet().length, 1 );

    return _.timeOut( 1, function()
    {
      promise.then( function( got )
      {
        test.identical( got, testMsg + 1 );
        test.is( _.promiseIs( promise ) );
        test.identical( con.resourcesGet().length, 3 );
        test.identical( con.competitorsEarlyGet().length, 0 );
      })
      return _.Consequence.From( promise );
    })
  })
  .keep/*finally*/( function( arg )
  {
    wConsequence.prototype.AsyncResourceAdding = 0;
    wConsequence.prototype.AsyncCompetitorHanding = 0;
    return arg;
  })

  return que;
}

//

// function thenSealed_( test )
// {
//
//   var testCheck1 =
//
//     {
//       givSequence : [ 5 ],
//       got :
//       {
//         gotSequence : [],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence :
//         [
//           { err : undefined, value : 5, takerId : 'taker1' }
//         ],
//         throwErr : false
//       }
//     },
//     testCheck2 =
//     {
//       givSequence :
//       [
//         'err msg'
//       ],
//       got :
//       {
//         gotSequence : [],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence :
//         [
//           { err : 'err msg', value : void 0, takerId : 'taker1' }
//         ],
//         throwErr : false
//       }
//     },
//     testCheck3 =
//     {
//       givSequence : [ 5, 4 ],
//       got :
//       {
//         gotSequence : [],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence :
//         [
//           { err : undefined, value : 5, takerId : 'taker1' },
//           { err : undefined, value : 4, takerId : 'taker2' }
//         ],
//         throwErr : false
//       }
//     },
//     testCheck4 =
//     {
//       givSequence : [ 5 ],
//       got :
//       {
//         gotSequence : [],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence :
//         [
//           {
//             err : undefined,
//             value : 5,
//             takerId : 'taker1',
//             context : 'ContextConstructor',
//             sealed : 'bar' ,
//             contVariable : 'foo'
//           },
//         ],
//         throwErr : false
//       }
//     };
//
//
//   /* common wConsequence corespondent tests. */
//
//   test.case = 'single value in give sequence, and single taker : attached taker after value resolved';
//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( err, value )
//     {
//       var takerId = 'taker1';
//       got.gotSequence.push( { err, value, takerId } );
//     }
//
//     var con = _.Consequence();
//     con.take( givSequence.shift() );
//     try
//     {
//       con.thenSealed( undefined, testTaker1, [] );
//     }
//     catch( err )
//     {
//       got.throwErr = !! err;
//     }
//     test.identical( got, expected );
//   } )( testCheck1 );
//
//   /**/
//
//   test.case = 'single err in give sequence, and single taker : attached taker after value resolved';
//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( err, value )
//     {
//       var takerId = 'taker1';
//       got.gotSequence.push( { err, value, takerId } );
//     }
//
//     var con = _.Consequence();
//     try
//     {
//       con.error( givSequence.shift() );
//       con.thenSealed( undefined, testTaker1, [] );
//     }
//     catch( err )
//     {
//       got.throwErr = !! err;
//     }
//     test.identical( got, expected );
//   } )( testCheck2 );
//
//   /**/
//
//   test.case = 'test thenSealed in chain';
//
//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( err, value )
//     {
//       var takerId = 'taker1';
//       got.gotSequence.push( { err, value, takerId } );
//       value++;
//       return value;
//     }
//
//     function testTaker2( err, value )
//     {
//       var takerId = 'taker2';
//       got.gotSequence.push( { err, value, takerId } );
//     }
//
//     var con = _.Consequence();
//     for (var given of givSequence)
//       con.take( given );
//
//     try
//     {
//       con.thenSealed( undefined, testTaker1, [] );
//       con.thenSealed( undefined, testTaker2, [] );
//     }
//     catch( err )
//     {
//       got.throwErr = !! err;
//     }
//     test.identical( got, expected );
//   } )( testCheck3 );
//
//   /* test particular _onceGot features test. */
//
//   test.case = 'thenSealed with sealed context and argument';
//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( sealed, err, value )
//     {
//       console.log( sealed + err + value )
//       var takerId = 'taker1',
//         context = this.constructor.name,
//         contVariable = this.contVariable;
//         got.gotSequence.push( { err, value, takerId, context, contVariable, sealed } );
//     }
//
//     function ContextConstructor()
//     {
//       this.contVariable = 'foo';
//     }
//
//     var con = _.Consequence();
//
//     for( var given of givSequence )
//     {
//       con.take( given );
//     }
//
//     try
//     {
//       con.thenSealed( new ContextConstructor(), testTaker1, [ 'bar' ] );
//     }
//     catch( err )
//     {
//       console.log(err);
//       got.throwErr = !! err;
//     }
//     console.log(JSON.stringify(expected));
//     test.identical( got, expected );
//   } )( testCheck4 );
//
//
//   if( Config.debug )
//   {
//     var conDeb1 = _.Consequence();
//
//     test.case = 'missed context arguments';
//     test.shouldThrowError( function()
//     {
//       conDeb1.thenSealed( function( err, val) { logger.log( 'foo' ); } );
//     } );
//   }
//
// };

//

// function split( test )
// {
//   var testCheck1 =
//
//     {
//       givSequence : [ 5 ],
//       got :
//       {
//         gotSequence : [],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence :
//           [
//             { err : undefined, value : 5, takerId : 'taker1' }
//           ],
//         throwErr : false
//       }
//     },
//     testCheck2 =
//     {
//       givSequence :
//         [ 5 ],
//       got :
//       {
//         gotSequence : [],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence :
//           [
//             { err : undefined, value : 5, takerId : 'taker1' }
//           ],
//         throwErr : false
//       }
//     },
//     testCheck3 =
//     {
//       givSequence : [ 5, 4 ],
//       got :
//       {
//         gotSequence : [],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence :
//           [
//             { err : undefined, value : 5, takerId : 'taker1' },
//           ],
//         throwErr : false
//       }
//     };
//
//
//   /* common wConsequence corespondent tests. */
//
//   test.case = 'finally clone : run after resolve value';
//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( err, value )
//     {
//       var takerId = 'taker1';
//       got.gotSequence.push( { err, value, takerId } );
//     }
//
//     var newCon;
//     var con = _.Consequence();
//     con.take( givSequence.shift() );
//     try
//     {
//       newCon = con.split();
//       newCon.got( testTaker1 )
//     }
//     catch( err )
//     {
//       got.throwErr = !! err;
//     }
//     test.identical( got, expected );
//   } )( testCheck1 );
//
//   /**/
//
//   test.case = 'finally clone : run before resolve value';
//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( err, value )
//     {
//       var takerId = 'taker1';
//       got.gotSequence.push( { err, value, takerId } );
//     }
//
//     var newCon;
//     var con = _.Consequence();
//     try
//     {
//       newCon = con.split();
//       newCon.got( testTaker1 );
//       con.take( givSequence.shift() );
//     }
//     catch( err )
//     {
//       got.throwErr = !! err;
//     }
//     test.identical( got, expected );
//   } )( testCheck2 );
//
//   /**/
//
//   test.case = 'test thenSealed in chain';
//
//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( err, value )
//     {
//       var takerId = 'taker1';
//       got.gotSequence.push( { err, value, takerId } );
//       value++;
//       return value;
//     }
//
//     function testTaker2( err, value )
//     {
//       var takerId = 'taker2';
//       got.gotSequence.push( { err, value, takerId } );
//     }
//
//     var con = _.Consequence();
//     for (var given of givSequence)
//       con.take( given );
//
//     var newCon;
//     try
//     {
//       newCon = con.split();
//       newCon.got( testTaker1 );
//       newCon.got( testTaker2 );
//     }
//     catch( err )
//     {
//       got.throwErr = !! err;
//     }
//     test.identical( got, expected );
//   } )( testCheck3 );
// };

//

function split( test )
{
  var que = new _.Consequence().take( null )

  .keep/*finally*/( function( arg )
  {
    test.case = 'split : run after resolve value';
    var con = new _.Consequence().take( 5 );
    var con2 = con.split();
    test.identical( con2.resourcesGet().length, 1 );
    con2.got( function( err, got )
    {
      test.identical( got, 5 );
      test.identical( err, undefined );
    });

    test.identical( con.resourcesGet().length, 1 );
    test.identical( con2.resourcesGet().length, 0 );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    test.case = 'split : run before resolve value';
    var con = new _.Consequence();
    var con2 = con.split();
    con2.got( function( err, got )
    {
      test.identical( got, 5 );
      test.identical( err, undefined );
    });
    con.take( 5 );
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con2.resourcesGet().length, 0 );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    test.case = 'test split in chain';
    var _got = [];
    var _err = [];
    function competitor( err, got )
    {
      _got.push( got );
      _err.push( err );
    }

    var con = new _.Consequence();
    con.take( 5 );
    con.take( 6 );
    test.identical( con.resourcesGet().length, 2 );
    var con2 = con.split();
    test.identical( con.resourcesGet().length, 2 );
    test.identical( con2.resourcesGet().length, 1 );
    con2.got( competitor );
    con2.got( competitor );

    test.identical( con2.resourcesGet().length, 0 );
    test.identical( con2.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 2 );
    test.identical( _got, [ 5 ] );
    test.identical( _err, [ undefined ] );

    con2.competitorCancel( competitor );
    test.identical( con2.resourcesGet().length, 0 );
    test.identical( con2.competitorsEarlyGet().length, 0 );

    return null;
  })

  .keep/*finally*/( function( arg )
  {
    test.case = 'passing competitor as argument';
    var _got = [];
    var _err = [];
    function competitor( err, got )
    {
      _got.push( got );
      _err.push( err );
      return null;
    }

    var con = new _.Consequence();
    con.take( 5 );
    con.take( 6 );
    test.identical( con.resourcesGet().length, 2 );
    var con2 = con.split( competitor );

    test.identical( con2.resourcesGet().length, 1 );
    test.identical( con2.resourcesGet()[ 0 ], { error : undefined, argument : null } );
    test.identical( con2.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 2 );
    test.identical( _got, [ 5 ] )
    test.identical( _err, [ undefined ] )
    return null;
  })

  return que;
}

//

function tap( test )
{
  var testMsg = 'msg';
  var que = new _.Consequence().take( null )

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'single value in give sequence, and single taker : attached taker after value resolved';

    var con = new _.Consequence();
    con.take( testMsg );
    con.tap( ( err, got ) => test.identical( got, testMsg ) );
    con.got( ( err, got ) => test.identical( got, testMsg ) );
    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'single error and single taker : attached taker after value resolved';

    var con = new _.Consequence();
    con.error( testMsg );
    con.tap( ( err, got ) => test.identical( err, testMsg ) );
    con.got( ( err, got ) => test.identical( err, testMsg ) );
    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'test tap in chain';

    var con = new _.Consequence();
    con.take( testMsg );
    con.tap( ( err, got ) => test.identical( got, testMsg ) );
    con.tap( ( err, got ) => test.identical( got, testMsg ) );
    con.got( ( err, got ) => test.identical( got, testMsg ) );
    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })

   /* */

  .keep/*finally*/( function( arg )
  {
    if( !Config.debug )
    return;

    test.case = 'missed arguments';

    var con = _.Consequence();

    test.shouldThrowError( function()
    {
      con.tap();
    });

    return null;
  })

  return que;
}

//

function tapHandling( test )
{
  var que = new _.Consequence().take( null )

  /* - */

  .keep( function( arg )
  {
    test.case = 'take at the end'

    var con = new _.Consequence();
    var visited = [ 0,0,0,0,0,0 ];

    con.take( null );

    con.keep( ( arg ) =>
    {
      debugger;
      visited[ 0 ] = 1;
      throw 'Error';
      return arg;
    });

    con.keep( ( arg ) =>
    {
      debugger;
      visited[ 1 ] = 1;
      return arg;
    });

    con.keep( ( arg ) =>
    {
      debugger;
      visited[ 2 ] = 1;
      return arg;
    });

    con.tap( ( err, arg ) =>
    {
      debugger;
      test.is( _.errIs( err ) );
      test.identical( arg, undefined );
      visited[ 3 ] = 1;
    });

    con.keep( ( arg ) =>
    {
      debugger;
      visited[ 4 ] = 1;
      return arg;
    });

    con.keep( ( arg ) =>
    {
      debugger;
      visited[ 5 ] = 1;
      return arg;
    });

    return _.timeOut( 50, () =>
    {
      test.identical( visited, [ 1,0,0,1,0,0 ] );
      test.identical( con.errorsCount(), 1 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
    });

  })

  /* - */

  .keep( function( arg )
  {
    test.case = 'take at the end'

    var con = new _.Consequence();
    var visited = [ 0,0,0,0,0,0 ];

    con.keep( ( arg ) =>
    {
      debugger;
      visited[ 0 ] = 1;
      throw 'Error';
      return arg;
    });

    con.keep( ( arg ) =>
    {
      debugger;
      visited[ 1 ] = 1;
      return arg;
    });

    con.keep( ( arg ) =>
    {
      debugger;
      visited[ 2 ] = 1;
      return arg;
    });

    con.tap( ( err, arg ) =>
    {
      debugger;
      test.is( _.errIs( err ) );
      test.identical( arg, undefined );
      visited[ 3 ] = 1;
    });

    con.keep( ( arg ) =>
    {
      debugger;
      visited[ 4 ] = 1;
      return arg;
    });

    con.keep( ( arg ) =>
    {
      debugger;
      visited[ 5 ] = 1;
      return arg;
    });

    con.take( null );

    return _.timeOut( 50, () =>
    {
      test.identical( visited, [ 1,0,0,1,0,0 ] );
      test.identical( con.errorsCount(), 1 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
    });

  })

  /* - */

  return que;
}

//

// function except( test )
// {

//   var testCheck1 =

//     {
//       givSequence : [ 5 ],
//       got :
//       {
//         gotSequence : [],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence : [],
//         throwErr : false
//       }
//     },
//     testCheck2 =
//     {
//       givSequence :
//         [
//           'err msg'
//         ],
//       got :
//       {
//         gotSequence : [],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence :
//           [
//             { err : 'err msg', takerId : 'taker1' }
//           ],
//         throwErr : false
//       }
//     },
//     testCheck3 =
//     {
//       givSequence : [ 5, 'err msg',  4 ],
//       got :
//       {
//         gotSequence : [],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence :
//           [
//             { err : undefined, value : 5, takerId : 'taker3' },
//           ],
//         throwErr : false
//       }
//     };


//   /* common wConsequence corespondent tests. */

//   test.case = 'single value in give sequence, and single taker : attached taker after value resolved';
//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( err )
//     {
//       var takerId = 'taker1';
//       got.gotSequence.push( { err, takerId } );
//     }

//     var con = _.Consequence();
//     con.take( givSequence.shift() );
//     try
//     {
//       con.except( testTaker1 );
//     }
//     catch( err )
//     {
//       got.throwErr = !! err;
//     }
//     test.identical( got, expected );
//   } )( testCheck1 );

//   /**/

//   test.case = 'single err in give sequence, and single taker : attached taker after value resolved';
//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( err )
//     {
//       var takerId = 'taker1';
//       got.gotSequence.push( { err, takerId } );
//     }

//     var con = _.Consequence();
//     try
//     {
//       con.error( givSequence.shift() );
//       con.except( testTaker1 );
//     }
//     catch( err )
//     {
//       got.throwErr = !! err;
//     }
//     test.identical( got, expected );
//   } )( testCheck2 );

//   /**/

//   test.case = 'test tap in chain';

//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( err )
//     {
//       var takerId = 'taker1';
//       got.gotSequence.push( { err,takerId } );
//       value++;
//       return value;
//     }

//     function testTaker2( err )
//     {
//       var takerId = 'taker2';
//       got.gotSequence.push( { err,takerId } );
//     }

//     function testTaker3( err, value )
//     {
//       var takerId = 'taker3';
//       got.gotSequence.push( { err, value, takerId } );
//     }

//     var con = _.Consequence();

//     con.take( givSequence.shift() );
//     con.error( givSequence.shift() );
//     con.take( givSequence.shift() );

//     try
//     {
//       con.except( testTaker1 );
//       con.except( testTaker2 );
//       con.got( testTaker3 );

//     }
//     catch( err )
//     {
//       got.throwErr = !! err;
//     }
//     test.identical( got, expected );
//   } )( testCheck3 );

//   if( Config.debug )
//   {
//     var conDeb1 = _.Consequence();

//     test.case = 'missed arguments';
//     test.shouldThrowError( function()
//     {
//       conDeb1.except();
//     } );
//   }

// };

//

function except( test )
{
  var testMsg = 'msg';
  var que = new _.Consequence().take( null )

  /* common wConsequence corespondent tests. */

  .keep/*finally*/( function( arg )
  {
    test.case = 'single value in give sequence, and single taker : attached taker after value resolved';

    var con = new _.Consequence();
    con.take( testMsg );
    con.except( ( err ) => { test.identical( 0, 1 ); return null; } );
    con.got( ( err, got ) => test.identical( got, testMsg ));

    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );

    return arg;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'single err in give sequence, and single taker : attached taker after value resolved';

    var con = new _.Consequence();
    con.error( testMsg );
    con.except( ( err ) => { test.identical( err,testMsg ); return null; });
    con.got( ( err, got ) => test.identical( got, null ) );

    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );

    return arg;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'test except in chain, regular resource is given before error';

    var con = new _.Consequence();
    con.take( testMsg );
    con.error( testMsg + 1 );
    con.error( testMsg + 2 );

    con.except( ( err ) => { test.identical( 0, 1 ); return null; });
    con.except( ( err ) => { test.identical( 0, 1 ); return null; });
    con.got( ( err, got ) => test.identical( got, testMsg ) );

    test.identical( con.resourcesGet().length, 2 );
    test.identical( con.resourcesGet()[ 0 ].error, testMsg + 1 );
    test.identical( con.resourcesGet()[ 1 ].error, testMsg + 2 );
    test.identical( con.competitorsEarlyGet().length, 0 );

    return arg;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'test except in chain, regular resource is given after error';

    var con = new _.Consequence();
    con.error( testMsg + 1 );
    con.error( testMsg + 2 );
    con.take( testMsg );

    con.except( ( err ) => { test.identical( err, testMsg + 1 ); return null; });
    con.except( ( err ) => { test.identical( err, testMsg + 2 ); return null; });
    con.got( ( err, got ) => test.identical( got, testMsg ) );

    test.identical( con.resourcesGet().length, 2 );
    test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : null } );
    test.identical( con.resourcesGet()[ 1 ], { error : undefined, argument : null } );
    test.identical( con.competitorsEarlyGet().length, 0 );

    return arg;
  })

   /* */

  .keep/*finally*/( function( arg )
  {
    if( !Config.debug )
    return;

    test.case = 'missed arguments';

    var con = _.Consequence();

    return test.shouldThrowErrorSync( function()
    {
      con.except();
    });

  })

  return que;
}

//

function deasync( test )
{
  let self = this;
  let testMsg = 'msg';

  test.case = 'simplest take';
  var con = new _.Consequence();
  con.take( testMsg );
  var got = con.deasync();
  test.identical( got, testMsg );

  con.finally( ( err, got ) =>
  {
    test.identical( err, undefined );
    test.identical( got, testMsg );

    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );

    return null;
  })
  var got = con.deasync();
  test.identical( got, null );

  //

  test.case = 'simplest error';
  var con = new _.Consequence();
  con.error( testMsg );
  test.shouldThrowError( () => con.deasync() )
  con.finally( ( err, got ) =>
  {
    test.identical( err, testMsg );
    test.identical( got, undefined );

    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );

    return null;
  })
  var got = con.deasync();
  test.identical( got, null );

  //

  test.case = 'timeOut';
  var time1 = _.timeNow();
  var con = _.timeOut( 150, () => testMsg );
  var got = con.deasync();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 150 );
  test.identical( got, testMsg )
  con.finally( ( err, got ) =>
  {
    test.identical( err, undefined );
    test.identical( got, testMsg );

    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );

    return null;
  })
  var got = con.deasync();
  test.identical( got, null );

  //

  test.case = 'several competitors';
  var con = new _.Consequence().take( testMsg );
  var order = [];

  con.keep( ( got ) =>
  {
    order.push( 'keep1' );
    test.identical( got, testMsg );
    return got;
  })

  var got = con.deasync();
  order.push( 'deasync1' );
  test.identical( got, testMsg );

  con.keep( ( got ) =>
  {
    order.push( 'keep2' );
    test.identical( got, testMsg );
    return got;
  })

  var got = con.deasync();
  order.push( 'deasync2' );
  test.identical( got, testMsg );

  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 1 );

  test.identical( order, [ 'keep1', 'deasync1', 'keep2', 'deasync2' ] )

  //

  test.case = 'sync timeouts';
  var time1 = _.timeNow();
  var got = [];
  _.timeOut( 100, () => { got.push( 1 ); return 1 } ).deasync();
  _.timeOut( 100, () => { got.push( 2 ); return 2 } ).deasync();
  _.timeOut( 100, () => { got.push( 3 ); return 3 } ).deasync();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 300 );
  test.identical( got, [ 1,2,3 ] )

  //

  test.case = 'sync andThen'
  var con = new _.Consequence().take( null );
  var time1 = _.timeNow();
  con.andKeep
  ([
    _.timeOut( 100, () => 1 ),
    _.timeOut( 120, () => 2 )
  ])
  var got = con.deasync();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 120 );
  test.identical( got, [ 1,2,null ] );

  //

  test.case = 'sync chain'
  var con = new _.Consequence().take( null );
  var time1 = _.timeNow();
  con.keep( () => _.timeOut( 50, () => 1 ) )
  con.keep( () => _.timeOut( 50, () => 2 ) )
  con.keep( () => _.timeOut( 50, () => 3 ) )
  var got = con.deasync();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 150 );
  test.identical( got, 3 );

}

//

function finallyDeasyncGive( test )
{
  let self = this;
  let testMsg = 'msg';

  test.case = 'simplest take';
  var con = new _.Consequence();
  con.take( testMsg );
  var got = con.finallyDeasyncGive();
  test.identical( got, testMsg );
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );

  //

  test.case = 'simplest error';
  var con = new _.Consequence();
  con.error( testMsg );
  test.shouldThrowError( () => con.finallyDeasyncGive() )
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );

  //

  test.case = 'timeOut';
  var time1 = _.timeNow();
  var con = _.timeOut( 150, () => testMsg );
  var got = con.finallyDeasyncGive();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 150 );
  test.identical( got, testMsg )
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );

  //

  test.case = 'several competitors';
  var con = new _.Consequence().take( testMsg );

  con.keep( ( got ) =>
  {
    test.identical( got, testMsg );
    return 'keep1';
  })

  var got = con.finallyDeasyncGive();
  test.identical( got, 'keep1' );
  test.identical( con.resourcesGet().length, 0 );
  con.take( 'deasync1' )

  con.keep( ( got ) =>
  {
    test.identical( got, 'deasync1' )
    return 'keep2';
  })

  var got = con.finallyDeasyncGive();
  test.identical( got, 'keep2' );

  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );

  //

  test.case = 'sync timeouts';
  var time1 = _.timeNow();
  var got = [];
  _.timeOut( 100, () => { got.push( 1 ); return 1 } ).finallyDeasyncGive();
  _.timeOut( 100, () => { got.push( 2 ); return 2 } ).finallyDeasyncGive();
  _.timeOut( 100, () => { got.push( 3 ); return 3 } ).finallyDeasyncGive();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 300 );
  test.identical( got, [ 1,2,3 ] )

  //

  test.case = 'sync andThen'
  var con = new _.Consequence().take( null );
  var time1 = _.timeNow();
  con.andKeep
  ([
    _.timeOut( 100, () => 1 ),
    _.timeOut( 120, () => 2 )
  ])
  var got = con.finallyDeasyncGive();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 120 );
  test.identical( got, [ 1,2,null ] );
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );

  //

  test.case = 'sync chain'
  var con = new _.Consequence().take( null );
  var time1 = _.timeNow();
  con.keep( () => _.timeOut( 50, () => 1 ) )
  con.keep( () => _.timeOut( 50, () => 2 ) )
  con.keep( () => _.timeOut( 50, () => 3 ) )
  var got = con.finallyDeasyncGive();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 150 );
  test.identical( got, 3 );
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );

}

//

function thenDeasyncGive( test )
{
  let self = this;
  let testMsg = 'msg';

  test.case = 'simplest take';
  var con = new _.Consequence();
  con.take( testMsg );
  var got = con.thenDeasyncGive();
  test.identical( got, testMsg );
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );

  //

  test.case = 'simplest error';
  var con = new _.Consequence();
  con.error( testMsg );
  var got = con.thenDeasyncGive();
  test.is( _.consequenceIs( got ) )
  test.identical( got.competitorsEarlyGet().length, 0 );
  test.identical( got.competitorsCount(), 0 );
  test.identical( got.resourcesGet(),[{ error : testMsg, argument : undefined }] );

  //

  test.case = 'timeOut';
  var time1 = _.timeNow();
  var con = _.timeOut( 150, () => testMsg );
  var got = con.thenDeasyncGive();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 150 );
  test.identical( got, testMsg )
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );

  //

  test.case = 'several competitors';
  var con = new _.Consequence().take( testMsg );

  con.keep( ( got ) =>
  {
    test.identical( got, testMsg );
    return 'keep1';
  })

  var got = con.thenDeasyncGive();
  test.identical( got, 'keep1' );
  test.identical( con.resourcesGet().length, 0 );
  con.take( 'deasync1' )

  con.keep( ( got ) =>
  {
    test.identical( got, 'deasync1' )
    return 'keep2';
  })

  var got = con.thenDeasyncGive();
  test.identical( got, 'keep2' );

  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );

  //

  test.case = 'sync timeouts';
  var time1 = _.timeNow();
  var got = [];
  _.timeOut( 100, () => { got.push( 1 ); return 1 } ).thenDeasyncGive();
  _.timeOut( 100, () => { got.push( 2 ); return 2 } ).thenDeasyncGive();
  _.timeOut( 100, () => { got.push( 3 ); return 3 } ).thenDeasyncGive();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 300 );
  test.identical( got, [ 1,2,3 ] )

  //

  test.case = 'sync andThen'
  var con = new _.Consequence().take( null );
  var time1 = _.timeNow();
  con.andKeep
  ([
    _.timeOut( 100, () => 1 ),
    _.timeOut( 120, () => 2 )
  ])
  var got = con.thenDeasyncGive();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 120 );
  test.identical( got, [ 1,2,null ] );
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );

  //

  test.case = 'sync chain'
  var con = new _.Consequence().take( null );
  var time1 = _.timeNow();
  con.keep( () => _.timeOut( 50, () => 1 ) )
  con.keep( () => _.timeOut( 50, () => 2 ) )
  con.keep( () => _.timeOut( 50, () => 3 ) )
  var got = con.thenDeasyncGive();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 150 );
  test.identical( got, 3 );
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );

}

//

function thenDeasyncKeep( test )
{
  let self = this;
  let testMsg = 'msg';

  test.case = 'simplest take';
  var con = new _.Consequence();
  con.take( testMsg );
  var got = con.thenDeasyncKeep();
  test.identical( got, testMsg );
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 1 );

  //

  test.case = 'simplest error';
  var con = new _.Consequence();
  con.error( testMsg );
  var got = con.thenDeasyncKeep();
  test.is( _.consequenceIs( got ) )
  test.identical( got.competitorsEarlyGet().length, 0 );
  test.identical( got.competitorsCount(), 0 );
  test.identical( got.resourcesGet(),[{ error : testMsg, argument : undefined }] );

  //

  test.case = 'timeOut';
  var time1 = _.timeNow();
  var con = _.timeOut( 150, () => testMsg );
  var got = con.thenDeasyncKeep();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 150 );
  test.identical( got, testMsg )
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 1 );

  //

  test.case = 'several competitors';
  var con = new _.Consequence().take( testMsg );

  con.keep( ( got ) =>
  {
    test.identical( got, testMsg );
    return 'keep1';
  })

  var got = con.thenDeasyncKeep();
  test.identical( got, 'keep1' );
  test.identical( con.resourcesGet().length, 1 );

  con.keep( ( got ) =>
  {
    test.identical( got, 'keep1' )
    return 'keep2';
  })

  var got = con.thenDeasyncKeep();
  test.identical( got, 'keep2' );

  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 1 );

  //

  test.case = 'sync timeouts';
  var time1 = _.timeNow();
  var got = [];
  _.timeOut( 100, () => { got.push( 1 ); return 1 } ).thenDeasyncKeep();
  _.timeOut( 100, () => { got.push( 2 ); return 2 } ).thenDeasyncKeep();
  _.timeOut( 100, () => { got.push( 3 ); return 3 } ).thenDeasyncKeep();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 300 );
  test.identical( got, [ 1,2,3 ] )

  //

  test.case = 'sync andThen'
  var con = new _.Consequence().take( null );
  var time1 = _.timeNow();
  con.andKeep
  ([
    _.timeOut( 100, () => 1 ),
    _.timeOut( 120, () => 2 )
  ])
  var got = con.thenDeasyncKeep();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 120 );
  test.identical( got, [ 1,2,null ] );
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 1 );

  //

  test.case = 'sync chain'
  var con = new _.Consequence().take( null );
  var time1 = _.timeNow();
  con.keep( () => _.timeOut( 50, () => 1 ) )
  con.keep( () => _.timeOut( 50, () => 2 ) )
  con.keep( () => _.timeOut( 50, () => 3 ) )
  var got = con.thenDeasyncKeep();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 150 );
  test.identical( got, 3 );
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 1 );

}

//

function exceptDeasyncGive( test )
{
  let self = this;
  let testMsg = 'msg';

  test.case = 'simplest take';
  var con = new _.Consequence();
  con.take( testMsg );
  var got = con.exceptDeasyncGive();
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );
  test.is( _.consequenceIs( got ) );
  test.identical( got.competitorsEarlyGet().length, 0 );
  test.identical( got.competitorsCount(), 0 );
  test.identical( got.resourcesGet(), [{ error : undefined, argument : testMsg }] );

  //

  test.case = 'simplest error';
  var con = new _.Consequence();
  con.error( testMsg );
  test.shouldThrowError( () => con.exceptDeasyncGive() );
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );

  //

  test.case = 'timeOut';
  var time1 = _.timeNow();
  var con = _.timeOut( 150, () => testMsg );
  var got = con.exceptDeasyncGive();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 150 );
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );
  test.is( _.consequenceIs( got ) );
  test.identical( got.competitorsEarlyGet().length, 0 );
  test.identical( got.competitorsCount(), 0 );
  test.identical( got.resourcesGet(), [{ error : undefined, argument : testMsg }] );


  //

  test.case = 'several competitors';
  var con = new _.Consequence().take( testMsg );

  con.keep( ( got ) =>
  {
    test.identical( got, testMsg );
    return 'keep1';
  })

  var got = con.exceptDeasyncGive();
  test.identical( got.competitorsEarlyGet().length, 0 );
  test.identical( got.competitorsCount(), 0 );
  test.identical( got.resourcesGet(), [{ error : undefined, argument : 'keep1' }] );
  con.take( 'deasync1' )

  con.keep( ( got ) =>
  {
    test.identical( got, 'deasync1' )
    return 'keep2';
  })

  var got = con.exceptDeasyncGive();
  test.is( _.consequenceIs( got ) );
  test.identical( got.competitorsEarlyGet().length, 0 );
  test.identical( got.competitorsCount(), 0 );
  test.identical( got.resourcesGet(), [{ error : undefined, argument : 'keep2' }] );

  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );

  //

  test.case = 'sync timeouts';
  var time1 = _.timeNow();
  var got = [];
  _.timeOut( 100, () => { got.push( 1 ); return 1 } ).exceptDeasyncGive();
  _.timeOut( 100, () => { got.push( 2 ); return 2 } ).exceptDeasyncGive();
  _.timeOut( 100, () => { got.push( 3 ); return 3 } ).exceptDeasyncGive();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 300 );
  test.identical( got, [ 1,2,3 ] )

  //

  test.case = 'sync andThen'
  var con = new _.Consequence().take( null );
  var time1 = _.timeNow();
  con.andKeep
  ([
    _.timeOut( 100, () => 1 ),
    _.timeOut( 120, () => 2 )
  ])
  var got = con.exceptDeasyncGive();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 120 );
  test.is( _.consequenceIs( got ) );
  test.identical( got.competitorsEarlyGet().length, 0 );
  test.identical( got.competitorsCount(), 0 );
  test.identical( got.resourcesGet(), [{ error : undefined, argument : [ 1,2,null ] }] );

  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );

  //

  test.case = 'sync chain'
  var con = new _.Consequence().take( null );
  var time1 = _.timeNow();
  con.keep( () => _.timeOut( 50, () => 1 ) )
  con.keep( () => _.timeOut( 50, () => 2 ) )
  con.keep( () => _.timeOut( 50, () => 3 ) )
  var got = con.exceptDeasyncGive();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 150 );
  test.is( _.consequenceIs( got ) );
  test.identical( got.competitorsEarlyGet().length, 0 );
  test.identical( got.competitorsCount(), 0 );
  test.identical( got.resourcesGet(), [{ error : undefined, argument : 3 }] );

  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 0 );

}

//

function exceptDeasyncKeep( test )
{
  let self = this;
  let testMsg = 'msg';

  test.case = 'simplest take';
  var con = new _.Consequence();
  con.take( testMsg );
  var got = con.exceptDeasyncKeep();
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 1 );
  test.is( _.consequenceIs( got ) );
  test.identical( got.competitorsEarlyGet().length, 0 );
  test.identical( got.competitorsCount(), 0 );
  test.identical( got.resourcesGet(), [{ error : undefined, argument : testMsg }] );

  //

  test.case = 'simplest error';
  var con = new _.Consequence();
  con.error( testMsg );
  test.shouldThrowError( () => con.exceptDeasyncKeep() );
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 1 );

  //

  test.case = 'timeOut';
  var time1 = _.timeNow();
  var con = _.timeOut( 150, () => testMsg );
  var got = con.exceptDeasyncKeep();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 150 );
  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet().length, 1 );
  test.is( _.consequenceIs( got ) );
  test.identical( got.competitorsEarlyGet().length, 0 );
  test.identical( got.competitorsCount(), 0 );
  test.identical( got.resourcesGet(), [{ error : undefined, argument : testMsg }] );


  //

  test.case = 'several competitors';
  var con = new _.Consequence().take( testMsg );

  con.keep( ( got ) =>
  {
    test.identical( got, testMsg );
    return 'keep1';
  })

  var got = con.exceptDeasyncKeep();
  test.is( _.consequenceIs( got ) );
  test.identical( got.competitorsEarlyGet().length, 0 );
  test.identical( got.competitorsCount(), 0 );
  test.identical( got.resourcesGet(), [{ error : undefined, argument : 'keep1' }] );

  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet(), [{ error : undefined, argument : 'keep1' }] );

  con.keep( ( got ) =>
  {
    test.identical( got, 'keep1' )
    return 'keep2';
  })

  var got = con.exceptDeasyncKeep();
  test.is( _.consequenceIs( got ) );
  test.identical( got.competitorsEarlyGet().length, 0 );
  test.identical( got.competitorsCount(), 0 );
  test.identical( got.resourcesGet(), [{ error : undefined, argument : 'keep2' }] );

  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet(), [{ error : undefined, argument : 'keep2' }] );

  //

  test.case = 'sync timeouts';
  var time1 = _.timeNow();
  var got = [];
  _.timeOut( 100, () => { got.push( 1 ); return 1 } ).exceptDeasyncKeep();
  _.timeOut( 100, () => { got.push( 2 ); return 2 } ).exceptDeasyncKeep();
  _.timeOut( 100, () => { got.push( 3 ); return 3 } ).exceptDeasyncKeep();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 300 );
  test.identical( got, [ 1,2,3 ] )

  //

  test.case = 'sync andThen'
  var con = new _.Consequence().take( null );
  var time1 = _.timeNow();
  con.andKeep
  ([
    _.timeOut( 100, () => 1 ),
    _.timeOut( 120, () => 2 )
  ])
  var got = con.exceptDeasyncKeep();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 120 );
  test.is( _.consequenceIs( got ) );
  test.identical( got.competitorsEarlyGet().length, 0 );
  test.identical( got.competitorsCount(), 0 );
  test.identical( got.resourcesGet(), [{ error : undefined, argument : [ 1,2,null ] }] );

  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet(), [{ error : undefined, argument : [ 1,2,null ] }] );

  //

  test.case = 'sync chain'
  var con = new _.Consequence().take( null );
  var time1 = _.timeNow();
  con.keep( () => _.timeOut( 50, () => 1 ) )
  con.keep( () => _.timeOut( 50, () => 2 ) )
  con.keep( () => _.timeOut( 50, () => 3 ) )
  var got = con.exceptDeasyncKeep();
  var time2 = _.timeNow();
  test.ge( time2 - time1, 150 );
  test.is( _.consequenceIs( got ) );
  test.identical( got.competitorsEarlyGet().length, 0 );
  test.identical( got.competitorsCount(), 0 );
  test.identical( got.resourcesGet(), [{ error : undefined, argument : 3 }] );

  test.identical( con.competitorsEarlyGet().length, 0 );
  test.identical( con.competitorsCount(), 0 );
  test.identical( con.resourcesGet(), [{ error : undefined, argument : 3 }] );

}

//

// function keep( test )
// {

//   var testCheck1 =

//     {
//       givSequence : [ 5 ],
//       got :
//       {
//         gotSequence : [],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence :
//         [
//           { value : 5, takerId : 'taker1' }
//         ],
//         throwErr : false
//       }
//     },
//     testCheck2 =
//     {
//       givSequence :
//         [
//           'err msg'
//         ],
//       got :
//       {
//         gotSequence : [],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence :
//           [ ],
//         throwErr : false
//       }
//     },
//     testCheck3 =
//     {
//       givSequence : [ 5, 'err msg',  4 ],
//       got :
//       {
//         gotSequence : [],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence :
//           [
//             { value : 5, takerId : 'taker1' },
//             { err : 'err msg', value : void 0, takerId : 'taker3' },
//           ],
//         throwErr : false
//       }
//     };


//   /* common wConsequence corespondent tests. */

//   test.case = 'single value in give sequence, and single taker : attached taker after value resolved';
//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( value )
//     {
//       var takerId = 'taker1';
//       got.gotSequence.push( { value, takerId } );
//     }

//     var con = _.Consequence();
//     con.take( givSequence.shift() );
//     try
//     {
//       con.keep( testTaker1 );
//     }
//     catch( err )
//     {
//       got.throwErr = !! err;
//     }
//     test.identical( got, expected );
//   } )( testCheck1 );

//   /**/

//   test.case = 'single err in give sequence, and single taker : attached taker after value resolved';
//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( value )
//     {
//       var takerId = 'taker1';
//       got.gotSequence.push( { value, takerId } );
//     }

//     var con = _.Consequence();
//     try
//     {
//       con.error( givSequence.shift() );
//       con.keep( testTaker1 );
//     }
//     catch( err )
//     {
//       got.throwErr = !! err;
//     }
//     test.identical( got, expected );
//   } )( testCheck2 );

//   /**/

//   test.case = 'test keep in chain';

//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( value )
//     {
//       var takerId = 'taker1';
//       got.gotSequence.push( { value, takerId } );
//       value++;
//       return value;
//     }

//     function testTaker2( value )
//     {
//       var takerId = 'taker2';
//       got.gotSequence.push( {  value, takerId } );
//     }

//     function testTaker3( err, value )
//     {
//       var takerId = 'taker3';
//       got.gotSequence.push( { err, value, takerId } );
//     }

//     var con = _.Consequence();

//     con.take( givSequence.shift() );
//     con.error( givSequence.shift() );
//     con.take( givSequence.shift() );

//     try
//     {
//       con.keep( testTaker1 );
//       con.keep( testTaker2 );
//       con.got( testTaker3 );

//     }
//     catch( err )
//     {
//       got.throwErr = !! err;
//     }
//     test.identical( got, expected );
//   } )( testCheck3 );

//   if( Config.debug )
//   {
//     var conDeb1 = _.Consequence();

//     test.case = 'missed arguments';
//     test.shouldThrowError( function()
//     {
//       conDeb1.keep();
//     });
//   }

// };

//

function ifNoErrorGotTrivial( test )
{
  let con = new _.Consequence();
  let last = 0;

  con.take( 0 );
  con.toStr();

  con
  .ifNoErrorGot( ( arg ) =>
  {
    let result = _.Consequence().take( 1 );
    test.identical( arg, 0 );
    last = 1;
    return result;
  })
  .finally( ( err, arg ) =>
  {
    if( err )
    _.errLogOnce( err );
    last = 2
    return null;
  });

  return _.timeOut( 100, () =>
  {
    test.identical( last, 1 );
    con.competitorsCancel();
    return null;
  });

}

//

function ifNoErrorGotThrowing( test )
{
  let con = new _.Consequence();
  let last = 0;
  let error = null;

  con.take( 0 );
  con.toStr();

  con
  .ifNoErrorGot( ( arg ) =>
  {
    let result = _.Consequence().take( 1 );
    test.identical( arg, 0 );
    last = 1;
    // debugger;
    throw 'Throw error';
    return result;
  })
  .finally( ( err, arg ) =>
  {
    test.identical( arg, undefined );
    if( err )
    {
      // debugger;
      error = err;
      // _.errLogOnce( err );
      _.errAttend( err );
    }
    last = 2
    return null;
  });

  return _.timeOut( 100, () =>
  {
    test.identical( last, 2 );
    test.is( _.errIs( error ) );
    return null;
  });

}

//

function keep( test )
{
  var testMsg = 'msg';
  var que = new _.Consequence().take( null )

  /* common wConsequence corespondent tests. */

  .keep/*finally*/( function( arg )
  {
    test.case = 'single value in give sequence, and single taker : attached taker after value resolved';

    var con = new _.Consequence();
    con.take( testMsg );
    con.keep( ( got ) => { test.identical( got, testMsg ); return null; } );
    con.got( ( err, got ) => test.identical( got, null ) );

    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'single err in give sequence, and single taker : attached taker after value resolved';

    var con = new _.Consequence();
    con.error( testMsg );
    con.keep( ( got ) => { test.identical( 0, 1 ); return null; });
    con.got( ( err, got ) => test.identical( err, testMsg ) );

    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'test keep in chain, regular resource is given before error';

    var con = new _.Consequence();
    con.take( testMsg );
    con.take( testMsg );
    con.error( testMsg );

    con.keep( ( got ) => { test.identical( got, testMsg ); return null; });
    con.keep( ( got ) => { test.identical( got, testMsg ); return null; });

    test.identical( con.resourcesGet().length, 3 );
    test.identical( con.resourcesGet()[ 0 ].error, testMsg );
    test.identical( con.resourcesGet()[ 1 ], { error : undefined, argument : null } );
    test.identical( con.resourcesGet()[ 2 ], { error : undefined, argument : null } );
    test.identical( con.competitorsEarlyGet().length, 0 );
    return null;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'test keep in chain, regular resource is given after error';

    var con = new _.Consequence();
    con.error( testMsg );
    con.take( testMsg );
    con.take( testMsg );

    con.keep( ( got ) => { test.identical( 0, 1 ); return null; });
    con.keep( ( got ) => { test.identical( 0, 1 ); return null; });

    test.identical( con.resourcesGet().length, 3 );
    test.identical( con.resourcesGet()[ 0 ].error, testMsg );
    test.identical( con.resourcesGet()[ 1 ], { error : undefined, argument : testMsg } );
    test.identical( con.resourcesGet()[ 2 ], { error : undefined, argument : testMsg } );
    test.identical( con.competitorsEarlyGet().length, 0 );
    return null;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'test keep in chain serveral resources';

    var con = new _.Consequence();
    con.take( testMsg );
    con.take( testMsg );

    con.keep( ( got ) => { test.identical( got, testMsg ); return null; });
    con.keep( ( got ) => { test.identical( got, testMsg ); return null; });

    test.identical( con.resourcesGet().length, 2 );
    test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : null } );
    test.identical( con.resourcesGet()[ 1 ], { error : undefined, argument : null } );
    test.identical( con.competitorsEarlyGet().length, 0 );
    return null;
  })

   /* */

  .keep/*finally*/( function( arg )
  {
    if( !Config.debug )
    return;

    test.case = 'missed arguments';

    var con = _.Consequence();

    test.shouldThrowError( function()
    {
      con.keep();
    });
    return null;
  })

  return que;
}

//

// function timeOut( test )
// {

//   var testCheck1 =

//     {
//       givSequence : [ 5 ],
//       got :
//       {
//         gotSequence :
//         [
//           { err : undefined, value : 5, takerId : 'taker1' }
//         ],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence :
//           [
//             { err : undefined, value : 5, takerId : 'taker1' }
//           ],
//         throwErr : false
//       }
//     },
//     testCheck2 =
//     {
//       givSequence :
//         [
//           'err msg'
//         ],
//       got :
//       {
//         gotSequence : [],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence :
//           [ ],
//         throwErr : false
//       }
//     },
//     testCheck3 =
//     {
//       givSequence : [ 5, 3,  4 ],
//       got :
//       {
//         gotSequence : [],
//         throwErr : false
//       },
//       expected :
//       {
//         gotSequence :
//           [
//             { err : undefined, value : 4, takerId : 'taker3' },
//             { err : undefined, value : 3, takerId : 'taker2' },
//           ],
//         throwErr : false
//       }
//     };


//   /* common wConsequence corespondent tests. */

//   test.case = 'single value in give sequence, and single taker : attached taker after value resolved';
//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( err, value )
//     {
//       var takerId = 'taker1';
//       got.gotSequence.push( { err, value, takerId } );
//     }

//     var con = _.Consequence();
//     con.take( givSequence.shift() );
//     try
//     {
//       con.timeOut( 0, testTaker1 );
//     }
//     catch( err )
//     {
//       got.throwErr = !! err;
//     }
//     test.identical( got, expected );
//   } )( testCheck1 );

//   /**/

//   test.case = 'single err in give sequence, and single taker : attached taker after value resolved';
//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( err, value )
//     {
//       var takerId = 'taker1';
//       got.gotSequence.push( { err, value, takerId } );
//     }

//     var con = _.Consequence();
//     try
//     {
//       con.error( givSequence.shift() );
//       con.timeOut( 0, testTaker1 );
//     }
//     catch( err )
//     {
//       got.throwErr = !! err;
//     }
//     test.identical( got, expected );
//   } )( testCheck2 );

//   /**/

//   test.case = 'test timeOut in chain';

//   ( function( { givSequence, got, expected }  )
//   {
//     function testTaker1( err, value )
//     {
//       var takerId = 'taker1';
//       got.gotSequence.push( { err, value, takerId } );
//       value++;
//       return value;
//     }

//     function testTaker2( err, value )
//     {
//       var takerId = 'taker2';
//       got.gotSequence.push( { err, value, takerId } );
//     }

//     function testTaker3( err, value )
//     {
//       var takerId = 'taker3';
//       got.gotSequence.push( { err, value, takerId } );
//     }

//     var con = _.Consequence();

//     for (var given of givSequence)
//       con.take( given );

//     con.timeOut( 20, testTaker1 );
//     con.timeOut( 10, testTaker2 );
//     con.got( testTaker3 )
//     .got( function() {
//       test.identical( got, expected );
//     } );



//   } )( testCheck3 );

//   if( Config.debug )
//   {
//     var conDeb1 = _.Consequence();

//     test.case = 'missed arguments';
//     test.shouldThrowError( function()
//     {
//       conDeb1.timeOut();
//     } );
//   }

// };

//

function timeOut( test )
{
  var testMsg = 'msg';
  var que = new _.Consequence().take( null )

  /* common wConsequence corespondent tests. */

  .keep/*finally*/( function( arg )
  {
    test.case = 'single value in give sequence, and single taker : attached taker after value resolved';

    var con = new _.Consequence();
    con.take( testMsg );
    con.timeOut( 0, ( err, got ) => { test.identical( got, testMsg ); return null; } );
    con.got( ( err, got ) => test.identical( got, null ) );

    return _.timeOut( 0, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'single err in give sequence, and single taker : attached taker after value resolved';

    var con = new _.Consequence();
    con.error( testMsg );
    con.timeOut( 0, ( err, got ) => { test.identical( err, testMsg ); return null; } );
    con.got( ( err, got ) => test.identical( got, null ) );

    return _.timeOut( 0, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'test timeOut in chain';
    var delay = 0;
    var con = new _.Consequence();
    con.take( testMsg );
    con.take( testMsg + 1 );
    con.take( testMsg + 2 );
    con.timeOut( delay, ( err, got ) => { test.identical( got, testMsg ); return null; } );
    con.timeOut( ++delay, ( err, got ) => { test.identical( got, testMsg + 1 ); return null; } );
    con.timeOut( ++delay, ( err, got ) => { test.identical( got, testMsg + 2 ); return null; } );

    return _.timeOut( delay, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 3 );
      con.resourcesGet()
      .every( ( msg ) => test.identical( msg, { error : undefined, argument : null } ) )
      return null;
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    if( !Config.debug )
    return;

    var con = _.Consequence();

    test.case = 'missed arguments';
    test.shouldThrowError( function()
    {
      con.timeOut();
    });
    return null;
  })

  return que;
}

//

function andKeepRoutinesTakeFirst( test )
{
  var con = _.Consequence();
  var routines =
  [
    () => _.timeOut( 100, 0 ),
    () => _.timeOut( 100, 1 ),
    () => _.timeOut( 100, 2 ),
    () => _.timeOut( 100, 3 ),
    () => _.timeOut( 100, 4 ),
    () => _.timeOut( 100, 5 ),
    () => _.timeOut( 100, 6 ),
  ]

  con.take( null );
  con.andKeep( routines );

  con.finally( ( err, args ) =>
  {
    test.identical( err, undefined );
    test.identical( args, [ 0,1,2,3,4,5,6,null ] );
    if( err )
    throw err;
    return args;
  })

  return con;
}

//

function andKeepRoutinesTakeLast( test )
{
  var con = _.Consequence();
  var routines =
  [
    () => _.timeOut( 100, 0 ),
    () => _.timeOut( 100, 1 ),
    () => _.timeOut( 100, 2 ),
    () => _.timeOut( 100, 3 ),
    () => _.timeOut( 100, 4 ),
    () => _.timeOut( 100, 5 ),
    () => _.timeOut( 100, 6 ),
  ]

  con.andKeep( routines );

  con.finally( ( err, args ) =>
  {
    test.identical( err, undefined );
    test.identical( args, [ 0,1,2,3,4,5,6,null ] );
    if( err )
    throw err;
    return args;
  })

  con.take( null );

  return con;
}

//

function andKeepRoutinesDelayed( test )
{
  var con = _.Consequence();
  var routines =
  [
    () => _.timeOut( 100, 0 ),
    () => _.timeOut( 100, 1 ),
    () => _.timeOut( 100, 2 ),
    () => _.timeOut( 100, 3 ),
    () => _.timeOut( 100, 4 ),
    () => _.timeOut( 100, 5 ),
    () => _.timeOut( 100, 6 ),
  ]

  con.andKeep( routines );

  con.finally( ( err, args ) =>
  {
    test.identical( err, undefined );
    test.identical( args, [ 0,1,2,3,4,5,6,null ] );
    if( err )
    throw err;
    return args;
  })

  _.timeOut( 250, () =>
  {
    con.take( null );
    return true;
  });

  return con;
}

//

function andKeep( test )
{
  var testMsg = 'msg';
  var que = new _.Consequence().take( null )

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'andKeep waits only for first resource and return it back';
    var delay = 100;
    var mainCon = new _.Consequence();
    var con = new _.Consequence();

    mainCon.take( testMsg );

    debugger;
    mainCon.andKeep( con );
    debugger;

    mainCon.finally( function( err, got )
    {
      debugger;
      test.identical( got, [ delay, testMsg ] );
      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( con.resourcesGet(), [{ error : undefined, argument : delay }] );
      test.identical( con.competitorsEarlyGet().length, 0 );
      return null;
    });

    _.timeOut( delay, () => { con.take( delay ); return null; });
    _.timeOut( delay * 2, () => { con.take( delay * 2 ); return null; });

    return _.timeOut( delay * 2, function()
    {
      debugger;
      test.identical( con.resourcesGet().length, 2 );
      test.identical( con.resourcesGet()[ 1 ].argument, delay * 2 );
      return null;
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'andKeep waits for first resource from consequence returned by routine call and returns resource back';
    var delay = 100;
    var mainCon = new _.Consequence();
    var con = new _.Consequence();

    mainCon.take( testMsg );

    mainCon.andKeep( () => con );

    mainCon.finally( function( err, got )
    {
      test.identical( got, [ delay, testMsg ] );
      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( con.resourcesGet().length, 1 );
      test.identical( con.resourcesGet()[ 0 ], { error : undefined, argument : delay } );
      test.identical( con.competitorsEarlyGet().length, 0 );
      return null;
    });

    _.timeOut( delay, () => { con.take( delay );return null; });
    _.timeOut( delay * 2, () => { con.take( delay * 2 );return null; });

    return _.timeOut( delay * 2, function()
    {
      test.identical( con.resourcesGet().length, 2 );
      test.identical( con.resourcesGet()[ 1 ], { error : undefined, argument : delay * 2 } );
      return null;
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'give back resources to several consequences, different delays';
    var delay = 100;
    var mainCon = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();
    var con3 = new _.Consequence();

    var srcs = [ con1, con2, con3 ];

    mainCon.take( testMsg );

    mainCon.andKeep( srcs );

    mainCon.finally( function( err, got )
    {
      test.identical( got, [ delay, delay * 2, testMsg + testMsg, testMsg ] )
      test.identical( mainCon.resourcesGet().length, 0 );

      test.identical( con1.resourcesGet(), [ { error : undefined, argument : delay } ]);
      test.identical( con1.competitorsEarlyGet().length, 0 );

      test.identical( con2.resourcesGet(), [ { error : undefined, argument : delay * 2 } ]);
      test.identical( con2.competitorsEarlyGet().length, 0 );

      test.identical( con3.resourcesGet(), [ { error : undefined, argument : testMsg + testMsg } ]);
      test.identical( con3.competitorsEarlyGet().length, 0 );

      return null;
    });

    _.timeOut( delay, () => { con1.take( delay );return null; });
    _.timeOut( delay * 2, () => { con2.take( delay * 2 );return null; });
    con3.take( testMsg + testMsg );

    return mainCon;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'each con gives several resources, order of provided consequence is important';
    var delay = 100;
    var mainCon = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();
    var con3 = new _.Consequence();

    var srcs = [ con3, con1, con2  ];

    mainCon.take( testMsg );

    mainCon.andKeep( srcs );

    mainCon.finally( function( err, got )
    {
      test.identical( got, [ 'con3', 'con1', 'con2', testMsg ] );
      test.identical( mainCon.resourcesGet().length, 0 );

      test.identical( con1.resourcesGet().length, 3 );
      test.identical( con1.competitorsEarlyGet().length, 0 );

      test.identical( con2.resourcesGet().length, 3 );
      test.identical( con2.competitorsEarlyGet().length, 0 );

      test.identical( con3.resourcesGet().length, 3 );
      test.identical( con3.competitorsEarlyGet().length, 0 );

      return null;
    });

    _.timeOut( delay, () =>
    {
      con1.take( 'con1' );
      con1.take( 'con1' );
      con1.take( 'con1' );
      return null;
    });

    _.timeOut( delay * 2, () =>
    {
      con2.take( 'con2' );
      con2.take( 'con2' );
      con2.take( 'con2' );
      return null;
    });

    _.timeOut( delay / 2, () =>
    {
      con3.take( 'con3' );
      con3.take( 'con3' );
      con3.take( 'con3' );
      return null;
    });

    return mainCon;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'one of provided cons waits for another one to resolve';
    var delay = 100;
    var mainCon = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    var srcs = [ con1, con2  ];

    con1.take( null );
    con1.finally( () => con2 );
    con1.finally( () => 'con1' );

    mainCon.take( testMsg );

    mainCon.andTake( srcs );

    mainCon.finally( function( err, got )
    {
      test.identical( got, [ 'con1', 'con2', testMsg ] );

      test.identical( mainCon.resourcesGet().length, 0 );

      test.identical( con1.resourcesGet().length, 0 );
      test.identical( con1.competitorsEarlyGet().length, 0 );

      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 0 );
      return null;
    });

    _.timeOut( delay * 2, () => { con2.take( 'con2' ); return null;  } )

    return mainCon;
  })

  .keep/*finally*/( function( arg )
  {
    test.case =
    `consequence gives an error, only first error is taken into account
     other consequences are receiving their resources back`;

    var delay = 100;
    var mainCon = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    var srcs = [ con1, con2  ];

    mainCon.take( testMsg );

    mainCon.andKeep( srcs );

    mainCon.finally( function( err, got )
    {
      test.identical( err, 'con1' );
      test.identical( got, undefined );

      test.identical( mainCon.resourcesGet().length, 0 );

      test.identical( con1.resourcesGet().length, 1 );
      test.identical( con1.competitorsEarlyGet().length, 0 );

      test.identical( con2.resourcesGet().length, 1 );
      test.identical( con2.competitorsEarlyGet().length, 0 );
      return null;
    });

    _.timeOut( delay, () => { con1.error( 'con1' );return null;  } )
    var t = _.timeOut( delay * 2, () => { con2.take( 'con2' );return null;  } )

    t.finally( () =>
    {
      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 0 );
      return mainCon;
    })

    return t;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'passed consequence dont give any resource';
    var mainCon = new _.Consequence();
    var con = new _.Consequence();
    mainCon.take( null );
    mainCon.andKeep( con );
    mainCon.finally( () => { test.identical( 0, 1); return null; });
    test.identical( mainCon.resourcesGet().length, 0 );
    test.identical( mainCon.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 );

    return _.timeOut( 10, function()
    {
      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( mainCon.competitorsEarlyGet().length, 1 );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 1 );
      con.competitorsCancel();
      mainCon.competitorsCancel();
      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( mainCon.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
    });

  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'returned consequence dont give any resource';
    var mainCon = new _.Consequence();
    var con = new _.Consequence();
    mainCon.take( null );
    mainCon.andKeep( () => con );
    mainCon.finally( () => { test.identical( 0, 1); return null; });
    test.identical( mainCon.resourcesGet().length, 0 );
    test.identical( mainCon.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 );

    return _.timeOut( 10, function()
    {
      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( mainCon.competitorsEarlyGet().length, 1 );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 1 );
      con.competitorsCancel();
      mainCon.competitorsCancel();
      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( mainCon.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
    });

  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'one of srcs dont give any resource';
    var delay = 100;
    var mainCon = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();
    var con3 = new _.Consequence();

    var srcs = [ con1, con2, con3 ];

    mainCon.take( testMsg );

    mainCon.andKeep( srcs );

    mainCon.finally( () => { test.identical( 0, 1); return null; });

    _.timeOut( delay, () => { con1.take( delay );return null; });
    _.timeOut( delay * 2, () => { con2.take( delay * 2 );return null; });

    return _.timeOut( delay * 3, function()
    {

      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( mainCon.competitorsEarlyGet().length, 1 );
      test.identical( con1.resourcesGet().length, 0 );
      test.identical( con1.competitorsEarlyGet().length, 0 );
      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 0 );
      test.identical( con3.resourcesGet().length, 0 );
      test.identical( con3.competitorsEarlyGet().length, 1 );

      con3.competitorsCancel();
      mainCon.competitorsCancel();

      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( mainCon.competitorsEarlyGet().length, 0 );
      test.identical( con1.resourcesGet().length, 0 );
      test.identical( con1.competitorsEarlyGet().length, 0 );
      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 0 );
      test.identical( con3.resourcesGet().length, 0 );
      test.identical( con3.competitorsEarlyGet().length, 0 );

    });

  })

  return que;
}

//

function andTake( test )
{
  var testMsg = 'msg';
  var que = new _.Consequence().take( null )

   /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'andTake waits only for first resource, dont return the resource';
    var delay = 100;
    var mainCon = new _.Consequence();
    var con = new _.Consequence();

    mainCon.take( testMsg );

    mainCon.andTake( con );

    mainCon.finally( function( err, got )
    {
      test.identical( got, [ delay, testMsg ] )
      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      return null;
    });

    _.timeOut( delay, () => { con.take( delay ) });
    _.timeOut( delay * 2, () => { con.take( delay * 2 ) });

    return _.timeOut( delay * 2, function()
    {
      test.identical( con.resourcesGet().length, 1 );
      test.identical( con.resourcesGet()[ 0 ].argument, delay * 2 );
      return null;
    })
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'dont give resource back to single consequence returned from passed routine';
    var delay = 100;
    var mainCon = new _.Consequence();
    var con = new _.Consequence();

    mainCon.take( testMsg );

    mainCon.andTake( () => con );

    mainCon.finally( function( err, got )
    {
      test.identical( got, [ delay, testMsg ] );
      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
      return null;
    });

    _.timeOut( delay, () => { con.take( delay ); return null; });

    return mainCon;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'dont give resources back to several consequences with different delays';
    var delay = 100;
    var mainCon = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();
    var con3 = new _.Consequence();

    var srcs = [ con1, con2, con3 ];

    mainCon.take( testMsg );

    mainCon.andTake( srcs );

    mainCon.finally( function( err, got )
    {
      test.identical( got, [ delay, delay * 2, testMsg + testMsg, testMsg ] );

      test.identical( mainCon.resourcesGet().length, 0 );

      test.identical( con1.resourcesGet(), []);
      test.identical( con1.competitorsEarlyGet().length, 0 );

      test.identical( con2.resourcesGet(), []);
      test.identical( con2.competitorsEarlyGet().length, 0 );

      test.identical( con3.resourcesGet(), []);
      test.identical( con3.competitorsEarlyGet().length, 0 );

      return null;
    });

    _.timeOut( delay, () => { con1.take( delay ); return null; });
    _.timeOut( delay * 2, () => { con2.take( delay * 2 ); return null; });
    con3.take( testMsg + testMsg );

    return mainCon;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'each con gives several resources, order of provided consequence is important';
    var delay = 100;
    var mainCon = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();
    var con3 = new _.Consequence();

    var srcs = [ con3, con1, con2  ];

    mainCon.take( testMsg );

    mainCon.andTake( srcs );

    mainCon.finally( function( err, got )
    {
      test.identical( got, [ 'con3', 'con1', 'con2', testMsg ] );

      test.identical( mainCon.resourcesGet().length, 0 );

      test.identical( con1.resourcesGet().length, 2 );
      test.identical( con1.competitorsEarlyGet().length, 0 );

      test.identical( con2.resourcesGet().length, 2 );
      test.identical( con2.competitorsEarlyGet().length, 0 );

      test.identical( con3.resourcesGet().length, 2 );
      test.identical( con3.competitorsEarlyGet().length, 0 );

      return null;
    });

    _.timeOut( delay, () =>
    {
      con1.take( 'con1' );
      con1.take( 'con1' );
      con1.take( 'con1' );
      return null;
    });

    _.timeOut( delay * 2, () =>
    {
      con2.take( 'con2' );
      con2.take( 'con2' );
      con2.take( 'con2' );
      return null;
    });

    _.timeOut( delay / 2, () =>
    {
      con3.take( 'con3' );
      con3.take( 'con3' );
      con3.take( 'con3' );
      return null;
    });

    return mainCon;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'one of provided cons waits for another one to resolve';
    var delay = 100;
    var mainCon = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    var srcs = [ con1, con2  ];

    con1.take( null );
    con1.finally( () => con2 );
    con1.finally( () => 'con1' );

    mainCon.take( testMsg );

    mainCon.andTake( srcs );

    mainCon.finally( function( err, got )
    {
      test.identical( got, [ 'con1', 'con2', testMsg ] );

      test.identical( mainCon.resourcesGet().length, 0 );

      test.identical( con1.resourcesGet().length, 0 );
      test.identical( con1.competitorsEarlyGet().length, 0 );

      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 0 );

      return null;
    });

    _.timeOut( delay * 2, () => { con2.take( 'con2' ); return null; } )

    return mainCon;
  })

  .keep/*finally*/( function( arg )
  {
    test.case = 'consequence gives an error, only first error is taken into account';

    var delay = 100;
    var mainCon = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    var srcs = [ con1, con2  ];

    mainCon.take( testMsg );

    mainCon.andTake( srcs );

    mainCon.finally( function( err, got )
    {
      test.identical( err, 'con1' );
      test.identical( got, undefined );

      test.identical( mainCon.resourcesGet().length, 0 );

      test.identical( con1.resourcesGet().length, 0 );
      test.identical( con1.competitorsEarlyGet().length, 0 );

      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 0 );

      return null;
    });

    _.timeOut( delay, () => { con1.error( 'con1' );return null;  } )
    var t = _.timeOut( delay * 2, () => { con2.take( 'con2' );return null;  } )

    t.finally( () =>
    {
      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 0 );
      return mainCon;
    })

    return t;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'passed consequence dont give any resource';
    var mainCon = new _.Consequence();
    var con = new _.Consequence();
    mainCon.take( null );
    mainCon.andTake( con );
    mainCon.finally( () => test.identical( 0, 1 ) );
    test.identical( mainCon.resourcesGet().length, 0 );
    test.identical( mainCon.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 );
    test.identical( con.competitorsEarlyGet().length, 1 );
    return _.timeOut( 10, function()
    {
      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( mainCon.competitorsEarlyGet().length, 1 );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 1 );
      con.competitorsCancel();
      mainCon.competitorsCancel();
      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( mainCon.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
    });
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'returned consequence dont give any resource';
    var mainCon = new _.Consequence();
    var con = new _.Consequence();
    mainCon.take( null );
    mainCon.andTake( () => con );
    mainCon.finally( () => test.identical( 0, 1 ) );
    test.identical( mainCon.resourcesGet().length, 0 );
    test.identical( mainCon.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 );
    test.identical( con.competitorsEarlyGet().length, 1 );

    return _.timeOut( 10, function()
    {
      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( mainCon.competitorsEarlyGet().length, 1 );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 1 );
      con.competitorsCancel();
      mainCon.competitorsCancel();
      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( mainCon.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con.competitorsEarlyGet().length, 0 );
    });

  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'one of srcs dont give any resource';
    var delay = 100;
    var mainCon = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();
    var con3 = new _.Consequence();

    var srcs = [ con1, con2, con3 ];

    mainCon.take( testMsg );

    mainCon.andTake( srcs );
    mainCon.finally( () => { test.identical( 0, 1); return null; });

    _.timeOut( delay, () => { con1.take( delay ); return null; });
    _.timeOut( delay * 2, () => { con2.take( delay * 2 ); return null; });

    return _.timeOut( delay * 3, function()
    {

      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( mainCon.competitorsEarlyGet().length, 1 );
      test.identical( con1.resourcesGet().length, 0 );
      test.identical( con1.competitorsEarlyGet().length, 0 );
      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 0 );
      test.identical( con3.resourcesGet().length, 0 );
      test.identical( con3.competitorsEarlyGet().length, 1 );

      con3.competitorsCancel();
      mainCon.competitorsCancel();

      test.identical( mainCon.resourcesGet().length, 0 );
      test.identical( mainCon.competitorsEarlyGet().length, 0 );
      test.identical( con1.resourcesGet().length, 0 );
      test.identical( con1.competitorsEarlyGet().length, 0 );
      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 0 );
      test.identical( con3.resourcesGet().length, 0 );
      test.identical( con3.competitorsEarlyGet().length, 0 );

    });

  })

  return que;
}

//

function _and( test )
{
  var testMsg = 'msg';
  var delay = 500;
  var que = new _.Consequence().take( null )

  /* common wConsequence corespondent tests. */

  .keep/*finally*/( function( arg )
  {
    test.case = 'give back resources to src consequences';

    var mainCon = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    mainCon.take( testMsg );

    mainCon._and({ competitors : [ con1, con2 ], taking : false, stackLevel : 1 });

    con1.got( ( err, got ) => { test.identical( got, delay ); return null; });
    con2.got( ( err, got ) => { test.identical( got, delay * 2 ); return null; });

    mainCon.finally( function( err, got )
    {
      //at that moment all resources from srcs are processed
      test.identical( con1.resourcesGet().length, 0 );
      test.identical( con1.competitorsEarlyGet().length, 0 );
      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 0 );
      test.identical( got, [ delay, delay * 2, testMsg ] );
      return null;
    });

    _.timeOut( delay, () => { con1.take( delay );return null; } );
    _.timeOut( delay * 2, () => { con2.take( delay * 2 );return null; } );

    return mainCon;
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'dont give back resources to src consequences';

    var mainCon = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    mainCon.take( testMsg );

    mainCon._and({ competitors : [ con1, con2 ], taking : true, stackLevel : 1 });

    con1.got( ( err, got ) => { test.identical( 0, 1 ); return null; });
    con2.got( ( err, got ) => { test.identical( 0, 1 ); return null; });

    mainCon.finally( function( err, got )
    {
      /* no resources returned back to srcs, their competitors must not be invoked */
      test.identical( con1.resourcesGet().length, 0 );
      test.identical( con1.competitorsEarlyGet().length, 1 );
      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 1 );
      test.identical( got, [ delay, delay * 2, testMsg ] );
      return null;
    });

    _.timeOut( delay, () => { con1.take( delay ); return null; });
    _.timeOut( delay * 2, () => { con2.take( delay * 2 ); return null; });

    return _.timeOut( delay * 3, () =>
    {
      test.identical( mainCon.resourcesGet().length, 1 );
      test.identical( mainCon.competitorsEarlyGet().length, 0 );
      test.identical( con1.resourcesGet().length, 0 );
      test.identical( con1.competitorsEarlyGet().length, 1 );
      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 1 );
      con1.competitorsCancel();
      con2.competitorsCancel();
      test.identical( mainCon.resourcesGet().length, 1 );
      test.identical( mainCon.competitorsEarlyGet().length, 0 );
      test.identical( con1.resourcesGet().length, 0 );
      test.identical( con1.competitorsEarlyGet().length, 0 );
      test.identical( con2.resourcesGet().length, 0 );
      test.identical( con2.competitorsEarlyGet().length, 0 );
    });

    // return mainCon;
  })

  return que;
}

//

function orKeeping( test )
{
  var que = new _.Consequence().take( null );

  que

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take0, orKeeping, take1, take2';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    let rcon = con.orKeeping([ con1, con2 ]);
    test.is( rcon === con );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con1.take( 1 );
    con2.take( 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 0 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 0 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con1.resourcesGet( 0 ), { argument : 1, error : undefined } );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      test.identical( con2.resourcesGet( 0 ), { argument : 2, error : undefined } );
      con.competitorsCancel();
    });
  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take1, take2, orKeeping, take0';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con1.take( 1 );
    con2.take( 2 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 1 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    let rcon = con.orKeeping([ con1, con2 ]);
    test.is( rcon === con );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 1 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    con.take( 0 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 2 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 1 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );

      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 1 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );

      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 0 );
      got += 100;

      return arg;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 101 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con.resourcesGet( 0 ), { argument : 0, error : undefined } );

      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con1.resourcesGet( 0 ), { argument : 1, error : undefined } );

      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      test.identical( con2.resourcesGet( 0 ), { argument : 2, error : undefined } );

      // con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take1, take2, orKeeping';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con1.take( 1 );
    con2.take( 2 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 1 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    let rcon = con.orKeeping([ con1, con2 ]);
    test.is( rcon === con );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 1 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    con.finallyKeep( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );

      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 1 );
      got = arg;

      return arg;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 1 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con.resourcesGet( 0 ), { argument : 1, error : undefined } );

      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con1.resourcesGet( 0 ), { argument : 1, error : undefined } );

      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      test.identical( con2.resourcesGet( 0 ), { argument : 2, error : undefined } );

    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take0, or, later take2, later take1';

    var got = null;
    var con = new _.Consequence({ tag : 'or' });
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.orKeeping([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con1.takeLater( 100, 1 );
    con2.takeLater( 50, 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 0 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 0 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );

      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con1.resourcesGet( 0 ), { argument : 1, error : undefined } );

      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      test.identical( con2.resourcesGet( 0 ), { argument : 2, error : undefined } );

      con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'or, later take1, later take2, take0';

    var got = null;
    var con = new _.Consequence({ tag : 'or' });
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.orKeeping([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 1 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 1 );

    con1.takeLater( 100, 1 );
    con2.takeLater( 50, 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 0 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    con.take( 0 );

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 0 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'now, take0, take0, orKeeping, take1';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );
    con.take( 10 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 2 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.orKeeping([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 2 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con1.take( 1 );
    con2.take( 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 10 );

    });

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 0 );
      got = arg;

    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 0 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
    });
  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'orKeeping, later take1, later take2, later take0';

    var got = null;
    var con = new _.Consequence({ tag : 'or' });
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.orKeeping([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 1 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 1 );

    con1.takeLater( 100, 1 );
    con2.takeLater( 50, 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 2 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      test.identical( err, undefined );
      test.identical( arg, 0 );
      got += 100;
      return got;
    });

    con.takeLater( 150, 0 );

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 102 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'now, take0, take0, orKeeping with nulls, take1';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );
    con.take( 10 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 2 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.orKeeping([ null, con1, null, con2, null ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 2 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con1.take( 1 );
    con2.take( 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 10 );

    });

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 0 );
      got = arg;

    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 0 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
    });
  })

  /* - */

  return que;
}

orKeeping.timeOut = 15000;

//

function orTaking( test )
{
  var que = new _.Consequence().take( null );

  que

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take0, orTaking, take1, take2';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    let rcon = con.orTaking([ con1, con2 ]);
    test.is( rcon === con );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con1.take( 1 );
    con2.take( 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 0 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 0 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con1.resourcesGet( 0 ), { argument : 1, error : undefined } );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      test.identical( con2.resourcesGet( 0 ), { argument : 2, error : undefined } );
      con.competitorsCancel();
    });
  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take1, take2, orTaking, take0';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con1.take( 1 );
    con2.take( 2 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 1 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    let rcon = con.orTaking([ con1, con2 ]);
    test.is( rcon === con );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    con.take( 0 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 2 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );

      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 1 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );

      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 0 );
      got += 100;

      return arg;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 101 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con.resourcesGet( 0 ), { argument : 0, error : undefined } );

      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );

      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      test.identical( con2.resourcesGet( 0 ), { argument : 2, error : undefined } );

      // con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take1, take2, orTaking';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con1.take( 1 );
    con2.take( 2 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 1 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    let rcon = con.orTaking([ con1, con2 ]);
    test.is( rcon === con );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    con.finallyKeep( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      test.identical( err, undefined );
      test.identical( arg, 1 );
      got = arg;

      return arg;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 1 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con.resourcesGet( 0 ), { argument : 1, error : undefined } );

      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );

      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      test.identical( con2.resourcesGet( 0 ), { argument : 2, error : undefined } );

    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take0, or, later take2, later take1';

    var got = null;
    var con = new _.Consequence({ tag : 'or' });
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.orTaking([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con1.takeLater( 100, 1 );
    con2.takeLater( 50, 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 0 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 0 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );

      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con1.resourcesGet( 0 ), { argument : 1, error : undefined } );

      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      test.identical( con2.resourcesGet( 0 ), { argument : 2, error : undefined } );

      con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'or, later take1, later take2, take0';

    var got = null;
    var con = new _.Consequence({ tag : 'or' });
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.orTaking([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 1 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 1 );

    con1.takeLater( 100, 1 );
    con2.takeLater( 50, 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 0 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    con.take( 0 );

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 0 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'orTaking, later take1, later take2, later take0';

    var got = null;
    var con = new _.Consequence({ tag : 'or' });
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.orTaking([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 1 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 1 );

    con1.takeLater( 100, 1 );
    con2.takeLater( 50, 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 2 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 0 );
      test.identical( err, undefined );
      test.identical( arg, 0 );
      got += 100;
      return got;
    });

    con.takeLater( 150, 0 );

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 102 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 0 );
      con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'now, take0, take0, orTaking, take1';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );
    con.take( 10 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 2 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.orTaking([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 2 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con1.take( 1 );
    con2.take( 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 10 );

    });

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 0 );
      got = arg;

    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 0 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
    });
  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'now, take0, take0, orTaking with nulls, take1';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );
    con.take( 10 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 2 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.orTaking([ null, con1, null, con2, null ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 2 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con1.take( 1 );
    con2.take( 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 10 );

    });

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 0 );
      got = arg;

    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 0 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
    });
  })

  /* - */

  return que;
}

orTaking.timeOut = 15000;

//

function thenOrKeepingNotFiring( test )
{
  var que = new _.Consequence().take( null );

  que

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'now, take0 take0 or';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 ).take( 10 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 2 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrKeeping([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 1 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 1 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 1 );

      test.identical( err, undefined );
      test.identical( arg, 10 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 10 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 1 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 1 );
      con.competitorsCancel();
      con1.competitorsCancel();
      con2.competitorsCancel();
    });
  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take0 or later take0';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrKeeping([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 1 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 1 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 1 );

      test.identical( err, undefined );
      test.identical( arg, 10 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    _.timeBegin( 1, () => con.take( 10 ) );

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 10 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 1 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 1 );
      con.competitorsCancel();
      con1.competitorsCancel();
      con2.competitorsCancel();
    });

  })

  /* - */

  return que;
}

thenOrKeepingNotFiring.timeOut = 15000;

//

function thenOrKeeping( test )
{
  var que = new _.Consequence().take( null );

  que

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take0, thenOrKeeping, take1, take2';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrKeeping([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 1 );

    con1.take( 1 );
    con2.take( 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 1 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 1 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      con.competitorsCancel();
    });
  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'error0, thenOrKeeping, take1, take2';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.error( 'error' );

    test.identical( con.errorsCount(), 1 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrKeeping([ con1, con2 ]);

    test.identical( con.errorsCount(), 1 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con1.take( 1 );
    con2.take( 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, 'error' );
      test.identical( arg, undefined );
      got = err;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 'error' );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      con.competitorsCancel();
    });
  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take1, take2, or, take0';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con1.take( 1 );
    con2.take( 2 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 1 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrKeeping([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 1 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 1 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    con.take( 0 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 1 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 1 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 1 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );

      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con1.resourcesGet( 0 ), { argument : 1, error : undefined } );

      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      test.identical( con2.resourcesGet( 0 ), { argument : 2, error : undefined } );

      con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take0, or, later take2, later take1';

    var got = null;
    var con = new _.Consequence({ tag : 'or' });
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrKeeping([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 1 );

    con1.takeLater( 100, 1 );
    con2.takeLater( 50, 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 2 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 2 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'or, later take1, later take2, take0';

    var got = null;
    var con = new _.Consequence({ tag : 'or' });
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrKeeping([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 1 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con1.takeLater( 100, 1 );
    con2.takeLater( 50, 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 2 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    con.take( 0 );

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 2 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'thenOrKeeping, later take1, later take2, later take0';

    var got = null;
    var con = new _.Consequence({ tag : 'or' });
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrKeeping([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 1 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con1.takeLater( 100, 1 );
    con2.takeLater( 50, 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 1 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return got;
    });

    con.takeLater( 150, 0 );

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 1 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take0, take0, thenOrKeeping, take1';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );
    con.take( 10 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 2 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrKeeping([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 1 );

    con1.take( 1 );
    con2.take( 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 10 );

    });

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 1 );
      got = arg;

    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 1 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
    });
  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take0, take0, or with null, take1, take2';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );
    con.take( 10 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 2 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrKeeping([ null, con1, null, con2, null ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 1 );

    con1.take( 1 );
    con2.take( 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 10 );

    });

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 1 );
      got = arg;

    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 1 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
    });
  })

  /* - */

  return que;
}

thenOrKeeping.timeOut = 15000;

//

function thenOrTaking( test )
{
  var que = new _.Consequence().take( null );

  que

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take0, or, take1, take2';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrTaking([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 1 );

    con1.take( 1 );
    con2.take( 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 1 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 1 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      con.competitorsCancel();
    });
  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'error0, thenOrTaking, take1, take2';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.error( 'error' );

    test.identical( con.errorsCount(), 1 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrTaking([ con1, con2 ]);

    test.identical( con.errorsCount(), 1 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con1.take( 1 );
    con2.take( 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, 'error' );
      test.identical( arg, undefined );
      got = err;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 'error' );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take1, take2, or, take0';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con1.take( 1 );
    con2.take( 2 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 1 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrTaking([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 1 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 1 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    con.take( 0 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );
    test.identical( con2.competitorsCount(), 0 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 1 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 1 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );

      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );

      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      test.identical( con2.resourcesGet( 0 ), { argument : 2, error : undefined } );

      con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take0, or, later take2, later take1';

    var got = null;
    var con = new _.Consequence({ tag : 'or' });
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrTaking([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 1 );

    con1.takeLater( 100, 1 );
    con2.takeLater( 50, 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 2 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 2 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 0 );
      con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'or, later take1, later take2, take0';

    var got = null;
    var con = new _.Consequence({ tag : 'or' });
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrTaking([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 1 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con1.takeLater( 100, 1 );
    con2.takeLater( 50, 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 2 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return null;
    });

    con.take( 0 );

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 2 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 1 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 0 );
      test.identical( con2.competitorsCount(), 0 );
      con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'thenOrTaking, later take1, later take2, later take0';

    var got = null;
    var con = new _.Consequence({ tag : 'or' });
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrTaking([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con.competitorsCount(), 1 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con1.takeLater( 100, 1 );
    con2.takeLater( 50, 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 1 );
      got = arg;

    });

    con.finally( ( err, arg ) =>
    {
      test.is( false );
      return got;
    });

    con.takeLater( 150, 0 );

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 1 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 1 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
      con.competitorsCancel();
    });

  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take0, take0, thenOrTaking, take1';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );
    con.take( 10 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 2 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrTaking([ con1, con2 ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 1 );

    con1.take( 1 );
    con2.take( 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 10 );

    });

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 1 );
      got = arg;

    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 1 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
    });
  })

  /* - */

  .thenKeep( function( arg )
  {
    test.case = 'take0, take0, or with null, take1, take2';

    var got = null;
    var con = new _.Consequence();
    var con1 = new _.Consequence();
    var con2 = new _.Consequence();

    con.take( 0 );
    con.take( 10 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 2 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 0 );

    con.thenOrTaking([ null, con1, null, con2, null ]);

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con.competitorsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.competitorsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 0 );
    test.identical( con2.competitorsCount(), 1 );

    con1.take( 1 );
    con2.take( 2 );

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 10 );

    });

    con.finallyGive( ( err, arg ) =>
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );

      test.identical( err, undefined );
      test.identical( arg, 1 );
      got = arg;

    });

    return _.timeOut( 200, function( err, arg )
    {
      test.identical( got, 1 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      test.identical( con1.errorsCount(), 0 );
      test.identical( con1.argumentsCount(), 0 );
      test.identical( con1.competitorsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );
      test.identical( con2.competitorsCount(), 0 );
    });
  })

  /* - */

  return que;
}

thenOrTaking.timeOut = 15000;

//

function inter( test )
{

  test.case = 'got';

  var con1 = new _.Consequence().take( 1 );
  var con2 = new _.Consequence();

  con1.got( con2 );

  test.identical( con1._resource.length, 0 );
  test.identical( con1._competitorEarly.length, 0 );
  // test.identical( con1._competitorLate.length, 0 );

  test.identical( con2._resource.length, 1 );
  test.identical( con2._competitorEarly.length, 0 );
  // test.identical( con2._competitorLate.length, 0 );

  /* */

  test.case = 'done';

  var con1 = new _.Consequence().take( 1 );
  var con2 = new _.Consequence();

  con1.done( con2 );

  test.identical( con1._resource.length, 0 );
  test.identical( con1._competitorEarly.length, 0 );
  // test.identical( con1._competitorLate.length, 0 );

  test.identical( con2._resource.length, 1 );
  test.identical( con2._competitorEarly.length, 0 );
  // test.identical( con2._competitorLate.length, 0 );

  /* */

  test.case = 'finally';

  var con1 = new _.Consequence().take( 1 );
  var con2 = new _.Consequence();

  con1.finally( con2 );

  test.identical( con1._resource.length, 1 );
  test.identical( con1._competitorEarly.length, 0 );
  // test.identical( con1._competitorLate.length, 0 );

  test.identical( con2._resource.length, 1 );
  test.identical( con2._competitorEarly.length, 0 );
  // test.identical( con2._competitorLate.length, 0 );

  /* */

  test.case = 'finally';

  var con1 = new _.Consequence().take( 1 );
  var con2 = new _.Consequence();

  con1.finally( con2 );

  test.identical( con1._resource.length, 1 );
  test.identical( con1._competitorEarly.length, 0 );
  // test.identical( con1._competitorLate.length, 0 );

  test.identical( con2._resource.length, 1 );
  test.identical( con2._competitorEarly.length, 0 );
  // test.identical( con2._competitorLate.length, 0 );

  /* */

  test.case = 'take';

  var con1 = new _.Consequence().take( 1 );
  var con2 = new _.Consequence();

  con2.take( con1 );

  test.identical( con1._resource.length, 0 );
  test.identical( con1._competitorEarly.length, 0 );
  // test.identical( con1._competitorLate.length, 0 );

  test.identical( con2._resource.length, 1 );
  test.identical( con2._competitorEarly.length, 0 );
  // test.identical( con2._competitorLate.length, 0 );

}

//

function concurrentTakeExperiment( test )
{
  var que = new _.Consequence().take( null );

  /* - */

  que
  .keep( () =>
  {
    debugger;
    var r = trivialSample();
    test.identical( r, 0 );
    return r;
  })
  .keep( () =>
  {
    debugger;
    var r = putSample();
    test.identical( r, [ 0,1 ] );
    return r;
  })
  .keep( () =>
  {
    var c = asyncSample();
    test.is( _.consequenceIs( c ) );
    c.finally( ( err, arg ) =>
    {
      test.is( err === undefined );
      test.identical( arg, [ 0,1,2 ] );
      if( err )
      throw err;
      return arg;
    });
    return c;
  })

  return que;

  /* */

  function trivialSample()
  {
    var con = new _.Consequence();
    var result = [];
    var array =
    [
      () => { console.log( 'sync0' ); return 0; },
      () => { console.log( 'sync1' ); return 1; },
    ]

    for( var a = 0 ; a < array.length ; a++ )
    con.got( 1 ).take( array[ a ]() );
    con.take( 0 );

    return con.toResourceMaybe();
  }

  /* */

  function putSample()
  {
    var result = [];
    var con = new _.Consequence();
    var array =
    [
      () => { return 0; },
      () => { return 1; },
    ]

    for( var a = 0 ; a < array.length ; a++ )
    _.after( array[ a ]() ).putKeep( result, a ).participateGive( con );
    con.wait().take( result );

    return con.toResourceMaybe();
  }

  /* */

  function asyncSample()
  {
    var result = [];
    var con = new _.Consequence();
    var array =
    [
      () => { return 0; },
      () => { return timeOut( 100, 1 ); },
      () => { return 2; },
    ]

    for( var a = 0 ; a < array.length ; a++ )
    _.after( array[ a ]() ).putKeep( result, a ).participateGive( con );
    con.wait().take( result );

    return con.toResourceMaybe();
  }

  /* */

  function timeOut( time, arg )
  {
    return _.timeOut( time, arg ).finally( function( err, arg )
    {
      debugger;
      if( err )
      throw err;
      return arg;
    });
  }

}

concurrentTakeExperiment.timeOut = 10000;
concurrentTakeExperiment.experimental = 0;

//

// function _onceGot( test )
// {

//   var conseqTester = _.Consequence(); // for correct testing async aspects of wConsequence

//   var testChecks =
//     [
//       {
//         givSequence: [ 5 ],
//         gotSequence: [],
//         expectedSequence:
//         [
//          { err: undefined, value: 5, takerId: 'taker1' }
//         ],
//       },
//       {
//         givSequence: [
//           'err msg'
//         ],
//         gotSequence: [],
//         expectedSequence:
//         [
//           { err: 'err msg', value: void 0, takerId: 'taker1' }
//         ]
//       },
//       {
//         givSequence: [ 5, 4 ],
//         gotSequence: [],
//         expectedSequence:
//           [
//             { err: undefined, value: 5, takerId: 'taker1' },
//             { err: undefined, value: 4, takerId: 'taker2' }
//           ],
//       },
//       {
//         givSequence: [ 5, 4, 6 ],
//         gotSequence: [],
//         expectedSequence:
//         [
//           { err: undefined, value: 5, takerId: 'taker1' },
//           { err: undefined, value: 4, takerId: 'taker1' },
//           { err: undefined, value: 6, takerId: 'taker2' }
//         ],
//       },
//       {
//         givSequence: [ 5, 4, 6 ],
//         gotSequence: [],
//         expectedSequence:
//         [
//           { err: undefined, value: 5, takerId: 'taker1' },
//           { err: undefined, value: 4, takerId: 'taker2' },
//         ],
//       },
//     ];

//   /* common wConsequence goter tests. */

//   test.case = 'single value in give sequence, and single taker: attached taker after value resolved';
//   ( function( { givSequence, gotSequence, expectedSequence }  )
//   {
//     function testTaker1( err, value )
//     {
//       var takerId = 'taker1';
//       gotSequence.push( { err, value, takerId } );
//     }

//     var con = _.Consequence();
//     con.take( givSequence.shift() );
//     con._onceGot( testTaker1 );
//     test.identical( gotSequence, expectedSequence );
//   } )( testChecks[ 0 ] );

//   /**/

//   test.case = 'single err in give sequence, and single taker: attached taker after value resolved';
//   ( function( { givSequence, gotSequence, expectedSequence }  )
//   {
//     function testTaker1( err, value )
//     {
//       var takerId = 'taker1';
//       gotSequence.push( { err, value, takerId } );
//     }

//     var con = _.Consequence();
//     con.error( givSequence.shift() );
//     con._onceGot( testTaker1 );
//     test.identical( gotSequence, expectedSequence );
//   } )( testChecks[ 1 ] );

//   /**/

//   test.case = 'test _onceGot in chain';

//   ( function( { givSequence, gotSequence, expectedSequence }  )
//   {
//     function testTaker1( err, value )
//     {
//       var takerId = 'taker1';
//       gotSequence.push( { err, value, takerId } );
//       value++;
//       return value;
//     }

//     function testTaker2( err, value )
//     {
//       var takerId = 'taker2';
//       gotSequence.push( { err, value, takerId } );
//     }

//     var con = _.Consequence();
//     for (var given of givSequence)
//     con.take( given );

//     con._onceGot( testTaker1 );
//     con._onceGot( testTaker2 );
//     test.identical( gotSequence, expectedSequence );
//   } )( testChecks[ 2 ] );

//   /* test particular _onceGot features test. */

//   test.case = 'several takers with same name: appending after given values are resolved';
//   ( function( { givSequence, gotSequence, expectedSequence }  )
//   {
//     function testTaker1( err, value )
//     {
//       var takerId = 'taker1';
//       gotSequence.push( { err, value, takerId } );
//     }

//     function testTaker2( err, value )
//     {
//       var takerId = 'taker2';
//       gotSequence.push( { err, value, takerId } );
//     }

//     var con = _.Consequence();

//     for( var given of givSequence ) // pass all values in givSequence to consequenced
//     {
//       con.take( given );
//     }

//     con._onceGot( testTaker1 );
//     con._onceGot( testTaker1 );
//     con._onceGot( testTaker2 );
//     test.identical( gotSequence, expectedSequence );
//   } )( testChecks[ 3 ] );

//   /**/

//   test.case = 'several takers with same name: appending before given values are resolved';
//   ( function( { givSequence, gotSequence, expectedSequence }  )
//   {
//     function testTaker1( err, value )
//     {
//       var takerId = 'taker1';
//       gotSequence.push( { err, value, takerId } );
//     }

//     function testTaker2( err, value )
//     {
//       var takerId = 'taker2';
//       gotSequence.push( { err, value, takerId } );
//     }

//     var con = new _.Consequence();
//     var que = new _.Consequence().take( null );

//     con._onceGot( testTaker1 );
//     con._onceGot( testTaker1 );
//     con._onceGot( testTaker2 );

//     for( var given of givSequence ) // pass all values in givSequence to consequenced
//     {
//       que.finally( () => con.take( given ) );
//     }

//     que.finally( () => test.identical( gotSequence, expectedSequence ) );
//   } )( testChecks[ 4 ] );

//   /**/

//   if( Config.debug )
//   {
//     var conDeb1 = _.Consequence();

//     test.case = 'try to pass as parameter anonymous function';
//     test.shouldThrowError( function()
//     {
//       conDeb1._onceGot( function( err, val) { logger.log( 'i am anonymous' ); } );
//     });

//     var conDeb2 = _.Consequence();

//     test.case = 'try to pass as parameter anonymous function(defined in expression)';

//     function testHandler( err, val) { logger.log( 'i am anonymous' ); }
//     test.shouldThrowError( function()
//     {
//       conDeb2._onceGot( testHandler );
//     } );
//   }

//   conseqTester.take( null );
//   return conseqTester;
// }

//

function _onceGot( test )
{
  var testMsg = 'msg';
  var que = new _.Consequence().take( null )

  /* common wConsequence goter tests. */

  .keep/*finally*/( function( arg )
  {
    test.case = 'single value in give sequence, and single taker: attached taker after value resolved';
    function competitor( err, got )
    {
      test.identical( got, testMsg );
      test.identical( err, undefined );
    }
    var con = new _.Consequence();
    con.take( testMsg );
    con._onceGot( competitor );
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'single err in give sequence, and single taker: attached taker after value resolved';

    function competitor( err, got )
    {
      test.identical( err, testMsg );
      test.identical( got, undefined );
    }
    var con = new _.Consequence();
    con.error( testMsg );
    con._onceGot( competitor );
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'test _onceGot in chain';

    function competitor1( err, got )
    {
      test.identical( got, testMsg + 1 );
      return testMsg + 3;
    }
    function competitor2( err, got )
    {
      test.identical( got, testMsg + 2 );
    }
    var con = new _.Consequence();
    con.take( testMsg + 1 );
    con.take( testMsg + 2 );
    con._onceGot( competitor1 );
    con._onceGot( competitor2 );
  })

  /* test particular _onceGot features test. */

  .keep/*finally*/( function( arg )
  {
    test.case = 'several takers with same name: appending after given values are resolved';
    var competitor1Count = 0;
    var competitor2Count = 0;
    function competitor1( err, got )
    {
      test.identical( got, testMsg );
      competitor1Count++;
    }
    function competitor2( err, got )
    {
      test.identical( got, testMsg );
      competitor2Count++;
    }
    var con = new _.Consequence();

    con.take( testMsg );
    con.take( testMsg );
    con.take( testMsg );
    con._onceGot( competitor1 );
    con._onceGot( competitor1 );
    con._onceGot( competitor2 );

    test.identical( competitor1Count, 2 );
    test.identical( competitor2Count, 1 );
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'several takers with same name: appending before given values are resolved';
    var competitor1Count = 0;
    var competitor2Count = 0;
    function competitor1( err, got )
    {
      test.identical( got, testMsg );
      competitor1Count++;
    }
    function competitor2( err, got )
    {
      test.identical( got, testMsg );
      competitor2Count++;
    }
    var con = new _.Consequence();

    con._onceGot( competitor1 );
    con._onceGot( competitor1 );
    con._onceGot( competitor2 );

    con.take( testMsg );
    con.take( testMsg );
    con.take( testMsg );

    test.identical( competitor1Count, 1 );
    test.identical( competitor2Count, 1 );
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    if( !Config.debug )
    return;

    var con = new _.Consequence();

    test.case = 'try to pass as parameter anonymous function';
    test.shouldThrowError( function()
    {
      con._onceGot( function( err, val) { logger.log( 'i am anonymous' ); } );
    });

    /* */

    test.case = 'try to pass as parameter anonymous function(defined in expression)';
    function testHandler( err, val ) { logger.log( 'i am anonymous' ); }
    test.shouldThrowError( function()
    {
      con._onceGot( testHandler );
    });
  })

  return que;
}

//

function _onceThen( test )
{
  var testMsg = 'msg';
  var que = new _.Consequence().take( null )

  /* common wConsequence corespondent tests. */

  .keep/*finally*/( function( arg )
  {
    test.case = 'single value in give sequence, and single taker: attached taker after value resolved';
    function competitor( err, got )
    {
      test.identical( got, testMsg );
      test.identical( err, undefined );
      return got;
    }
    var con = new _.Consequence();
    con.take( testMsg );
    con._onceThen( competitor );
    con.got( ( err, got ) => test.identical( got, testMsg ) );
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'single err in give sequence, and single taker: attached taker after value resolved';

    function competitor( err, got )
    {
      test.identical( err, testMsg );
      test.identical( got, undefined );
      return err;
    }
    var con = new _.Consequence();
    con.error( testMsg );
    con._onceThen( competitor );
    con.got( ( err, got ) => test.identical( got, testMsg ) );
  })

  /* */

  .keep/*finally*/( function( arg )
  {
    test.case = 'test _onceThen in chain';

    function competitor1( err, got )
    {
      test.identical( got, testMsg );
      return testMsg + 1;
    }
    function competitor2( err, got )
    {
      test.identical( got, testMsg );
      return testMsg + 2;
    }
    var con = new _.Consequence();
    con.take( testMsg );
    con.take( testMsg );
    con._onceThen( competitor1 );
    con._onceThen( competitor2 );
    con.got( ( err, got ) => test.identical( got, testMsg + 1 ) );
    con.got( ( err, got ) => test.identical( got, testMsg + 2 ) );
  })

  /* test particular _onceGot features test. */

  .keep/*finally*/( function( arg )
  {
    test.case = 'added several corespondents with same name';
    var competitor1Count = 0;
    var competitor2Count = 0;
    function competitor1( err, got )
    {
      test.identical( got, testMsg );
      competitor1Count++;
      return got;
    }
    function competitor2( err, got )
    {
      test.identical( got, testMsg );
      competitor2Count++;
      return got;
    }
    var con = new _.Consequence();

    con._onceThen( competitor1 );
    con._onceThen( competitor1 );
    con._onceThen( competitor2 );

    test.identical( con.competitorsEarlyGet().length, 2 );

    con.take( testMsg );

    test.identical( competitor1Count, 1 );
    test.identical( competitor2Count, 1 );

    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet()[ 0 ].argument, testMsg );

  })

  /* */

  .keep/*finally*/( function( arg )
  {
    if( !Config.debug )
    return;

    var con = new _.Consequence();

    test.case = 'try to pass as parameter anonymous function';
    test.shouldThrowError( function()
    {
      con._onceThen( function( err, val) { logger.log( 'i am anonymous' ); } );
    });

    /* */

    test.case = 'try to pass as parameter anonymous function(defined in expression)';
    function testHandler( err, val) { logger.log( 'i am anonymous' ); }
    test.shouldThrowError( function()
    {
      con._onceThen( testHandler );
    });
  })

  return que;
}

//

function first( test )
{
  var c = this;
  var amode = _.Consequence.AsyncModeGet();
  var testMsg = 'msg';
  var que = new _.Consequence().take( null )

  .finally( () =>
  {
    _.Consequence.AsyncModeSet([ 0, 0 ]);
    test.open( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 0' );
    return null;
  })

  /* - */

  .keep/*finally*/( function( arg )
  {
    test.case = 'simplest, empty routine';
    var con = new _.Consequence();
    con.first( () => null );
    con.take( testMsg );
    con.finally( function( err, got )
    {
      test.identical( got, null );
      test.identical( con.resourcesGet(), [{ error : undefined, argument : testMsg }] );
      return null;
    })
    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns something';
    var con = new _.Consequence();
    con.first( () => testMsg );
    con.take( testMsg + 2 );
    con.finally( function( err, got )
    {
      test.identical( got, testMsg );
      test.identical( con.resourcesGet(), [{ error : undefined, argument : testMsg + 2 }] );
      return null;
    })
    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine throws error';
    var con = new _.Consequence();
    con.first( () => { throw testMsg });
    con.finally( function( err, got )
    {
      test.is( _.errIs( err ) );
      test.identical( got, undefined );
      test.identical( con.resourcesGet(),[] );
      return null;
    })
    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns consequence with resource';
    var con = new _.Consequence();
    con.first( () => new _.Consequence().take( testMsg ));
    con.finally( function( err, got )
    {
      test.identical( err, undefined );
      test.identical( got, testMsg );
      test.identical( con.resourcesGet(),[] );
      return null;
    })
    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns consequence with err resource';
    var con = new _.Consequence();
    con.first( () => new _.Consequence().error( testMsg ));
    con.finally( function( err, got )
    {
      test.identical( err, testMsg );
      test.identical( got, undefined );
      test.identical( con.resourcesGet(),[] );
      return null;
    })
    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns consequence that gives resource with timeout';
    var con = new _.Consequence();
    var timeBefore = _.timeNow();
    con.first( () => _.timeOut( 250, () => null ));
    con.finally( function( err, got )
    {
      var delay = _.timeNow() - timeBefore;
      var description = test.case = 'delay ' + delay;
      test.ge( delay, 250 - c.timeAccuracy );
      test.case = description;
      test.identical( err, undefined );
      test.identical( got, null );
      test.identical( con.resourcesGet(),[] );
      return null;
    })
    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passed consequence shares own resource';
    var con = new _.Consequence();
    var con2 = new _.Consequence().take( testMsg );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );

    con.first( con2 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );

    con.finally( function( err, got )
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );

      test.identical( err, undefined );
      test.identical( got, testMsg );
      test.identical( con.resourcesGet(),[] );
      test.identical( con2.resourcesGet(), [{ error : undefined, argument : testMsg }] );
      return null;
    })

    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passed consequence shares own resource with timeout';
    var con = new _.Consequence();
    var con2 = _.timeOut( 250, () => testMsg );
    var timeBefore = _.timeNow();
    con.first( con2 );
    con.finally( function( err, got )
    {
      var delay = _.timeNow() - timeBefore;
      var description = test.case = 'delay ' + delay;
      test.ge( delay, 250 - c.timeAccuracy );
      test.case = description;
      test.identical( err, undefined );
      test.identical( got, testMsg );
      test.identical( con.resourcesGet(),[] );
      test.identical( con2.resourcesGet(),[{ error : undefined, argument : testMsg }] );
      return null;
    })
    return con;
  })

  /* Async competitors adding, Sync resources adding */

  .finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 0' );
    _.Consequence.AsyncModeSet([ 1, 0 ]);
    test.open( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 0' );
    return null;
  })

   .keep/*finally*/( function( arg )
  {
    test.case = 'simplest, empty routine';
    var con = new _.Consequence();
    con.first( () => null );
    con.take( testMsg );
    con.got( function( err, got )
    {
      test.identical( got, null );
      test.identical( con.resourcesGet(), [{ error : undefined, argument : testMsg }] );
      return null;
    })

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 1 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns something';
    var con = new _.Consequence();
    con.first( () => testMsg );
    con.take( testMsg + 2 );
    con.got( function( err, got )
    {
      test.identical( got, testMsg );
    })

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet(), [{ error : undefined, argument : testMsg + 2 }] );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine throws error';
    var con = new _.Consequence();
    con.first( () => { throw testMsg });
    con.got( function( err, got )
    {
      test.is( _.errIs( err ) );
      test.identical( got, undefined );
      test.identical( con.resourcesGet(),[] );
    })

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns consequence with resource';
    var con = new _.Consequence();
    con.first( () => new _.Consequence().take( testMsg ));
    con.got( function( err, got )
    {
      test.identical( err, undefined );
      test.identical( got, testMsg );
    })

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns consequence with err resource';
    var con = new _.Consequence();
    con.first( () => new _.Consequence().error( testMsg ));
    con.got( function( err, got )
    {
      test.identical( err, testMsg );
      test.identical( got, undefined );
      test.identical( con.resourcesGet(),[] );
    })
    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns consequence that gives resource with timeout';
    var con = new _.Consequence();
    var timeBefore = _.timeNow();
    con.first( () => _.timeOut( 250, () => null ));
    con.got( function( err, got )
    {
      var delay = _.timeNow() - timeBefore;
      var description = test.case = 'delay ' + delay;
      test.ge( delay, 250 - c.timeAccuracy );
      test.case = description;
      test.identical( err, undefined );
      test.identical( got, null );
      test.identical( con.resourcesGet(),[] );
    })
    return _.timeOut( 251, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passed consequence shares own resource';
    var con = new _.Consequence();
    var con2 = new _.Consequence().take( testMsg );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );

    con.first( con2 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );

    con.got( function( err, got )
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );

      test.identical( err, undefined );
      test.identical( got, testMsg );
      test.identical( con.resourcesGet(),[] );
      test.identical( con2.resourcesGet(), [{ error : undefined, argument : testMsg }] );

    })
    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passed consequence shares own resource with timeout';
    var con = new _.Consequence();
    var con2 = _.timeOut( 250, () => testMsg );
    var timeBefore = _.timeNow();
    con.first( con2 );
    con.got( function( err, got )
    {
      var delay = _.timeNow() - timeBefore;
      var description = test.case = 'delay ' + delay;
      test.ge( delay, 250 - c.timeAccuracy );
      test.case = description;
      test.identical( err, undefined );
      test.identical( got, testMsg );
      test.identical( con.resourcesGet(),[] );
      test.identical( con2.resourcesGet(),[{ error : undefined, argument : testMsg }] );
    })
    return _.timeOut( 251, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /* Sync competitors adding, Async resources adding */

  .finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 0' );
    _.Consequence.AsyncModeSet([ 0, 1 ]);
    test.open( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 1' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    test.case = 'simplest, empty routine';
    var con = new _.Consequence();
    con.got( function( err, got )
    {
      test.identical( err, undefined );
      test.identical( got, null );
    });

    test.identical( con.resourcesGet().length, 0 );
    test.identical( con.competitorsEarlyGet().length, 1 );

    con.first( () => null );

    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.competitorsEarlyGet().length, 1 );

    con.take( testMsg );

    test.identical( con.resourcesGet().length, 2 );
    test.identical( con.competitorsEarlyGet().length, 1 );

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet(), [{ error : undefined, argument : testMsg }] );
      return null;
    });

  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns something';
    var con = new _.Consequence();
    con.got( function( err, got )
    {
      test.identical( got, testMsg );
    })
    con.first( () => testMsg );

    con.take( testMsg + 2 );

    test.identical( con.resourcesGet().length, 2 );
    test.identical( con.competitorsEarlyGet().length, 1 );

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet(), [{ error : undefined, argument : testMsg + 2 }] );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine throws error';
    var con = new _.Consequence();

    debugger;
    con.first( () => { throw testMsg } );
    debugger;
    test.identical( con.resourcesGet().length, 1 );
    test.identical( con.errorsCount(), 1 );
    test.identical( con.argumentsCount(), 0 );

    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 1 );
      con.got( function( err, got )
      {
        test.is( _.errIs( err ) );
        test.identical( got, undefined );
      });
    })
    .keep/*finally*/( function( arg )
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns consequence with resource';
    var con = new _.Consequence();
    con.first( () => new _.Consequence().take( testMsg ) );

    test.identical( con.resourcesGet().length, 1 );

    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 1 );

      con.got( function( err, got )
      {
        test.identical( err, undefined );
        test.identical( got, testMsg );
      })
      return null;
    })
    .keep/*finally*/( function( arg )
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns consequence with err resource';
    var con = new _.Consequence();
    con.first( () => new _.Consequence().error( testMsg ));

    test.identical( con.resourcesGet().length, 1 );

    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 1 );


      con.got( function( err, got )
      {
        test.identical( err, testMsg );
        test.identical( got, undefined );
      })
      return null;
    })
    .keep/*finally*/( function( arg )
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns consequence that gives resource with timeout';
    var con = new _.Consequence();
    var timeBefore = _.timeNow();
    con.first( () => _.timeOut( 250, () => null ));

    test.identical( con.resourcesGet().length, 0 );

    return _.timeOut( 251, function()
    {
      test.identical( con.resourcesGet().length, 1 );

      con.got( function( err, got )
      {
        var delay = _.timeNow() - timeBefore;
        var description = test.case = 'delay ' + delay;
        test.ge( delay, 250 - c.timeAccuracy );
        test.case = description;
        test.identical( err, undefined );
        test.identical( got, null );
      })
      return null;
    })
    .keep/*finally*/( function( arg )
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passed consequence shares own resource';
    var con = new _.Consequence();
    var con2 = new _.Consequence().take( testMsg );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );

    con.first( con2 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 1 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );

    return _.timeOut( 1, function()
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );

      test.identical( con.resourcesGet().length, 1 );

      con.got( function( err, got )
      {
        test.identical( err, undefined );
        test.identical( got, testMsg );
      })
      return null;
    })
    .keep/*finally*/( function( arg )
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con2.resourcesGet().length, 1 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passed consequence shares own resource with timeout';
    var con = new _.Consequence();
    var con2 = _.timeOut( 250, () => testMsg );
    var timeBefore = _.timeNow();
    con.first( con2 );

    return _.timeOut( 251, function()
    {
      test.identical( con.resourcesGet().length, 1 );

      con.got( function( err, got )
      {
        var delay = _.timeNow() - timeBefore;
        var description = test.case = 'delay ' + delay;
        test.ge( delay, 250 - c.timeAccuracy );
        test.case = description;
        test.identical( err, undefined );
        test.identical( got, testMsg );
      })
      return null;
    })
    .keep/*finally*/( function( arg )
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con2.resourcesGet().length, 1 );
      return null;
    })
  })

  /* Async competitors adding, Async resources adding */

  .finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 0, AsyncResourceAdding : 1' );
    _.Consequence.AsyncModeSet([ 1, 1 ]);
    test.open( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 1' );
    return null;
  })

  .keep/*finally*/( function( arg )
  {
    test.case = 'simplest, empty routine';
    var con = new _.Consequence();
    con.got( function( err, got )
    {
      test.identical( got, null );
    });
    con.first( () => null );
    con.take( testMsg );

    test.identical( con.resourcesGet().length, 2 );
    test.identical( con.competitorsEarlyGet().length, 1 );

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet(), [{ error : undefined, argument : testMsg }] );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns something';
    var con = new _.Consequence();
    con.got( function( err, got )
    {
      test.identical( got, testMsg );
    })
    con.first( () => testMsg );

    con.take( testMsg + 2 );

    test.identical( con.resourcesGet().length, 2 );
    test.identical( con.competitorsEarlyGet().length, 1 );

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet(), [{ error : undefined, argument : testMsg + 2 }] );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine throws error';
    var con = new _.Consequence();
    con.first( () => { throw testMsg });
    con.got( function( err, got )
    {
      test.is( _.errIs( err ) );
      test.identical( got, undefined );
    });

    test.identical( con.resourcesGet().length, 0 );

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns consequence with resource';
    var con = new _.Consequence();
    con.first( () => new _.Consequence().take( testMsg ));
    con.got( function( err, got )
    {
      test.identical( err, undefined );
      test.identical( got, testMsg );
    })
    test.identical( con.resourcesGet().length, 0 );

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns consequence with err resource';
    var con = new _.Consequence();
    con.first( () => new _.Consequence().error( testMsg ));
    con.got( function( err, got )
    {
      test.identical( err, testMsg );
      test.identical( got, undefined );
    })
    test.identical( con.resourcesGet().length, 0 );

    return _.timeOut( 1, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'routine returns consequence that gives resource with timeout';
    var con = new _.Consequence();
    var timeBefore = _.timeNow();
    con.first( () => _.timeOut( 250, () => null ));
    con.got( function( err, got )
    {
      var delay = _.timeNow() - timeBefore;
      var description = test.case = 'delay ' + delay;
      test.ge( delay, 250 - c.timeAccuracy );
      test.case = description;
      test.identical( err, undefined );
      test.identical( got, null );
    })
    test.identical( con.resourcesGet().length, 0 );

    return _.timeOut( 251, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passed consequence shares own resource';
    var con = new _.Consequence();
    var con2 = new _.Consequence().take( testMsg );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );

    con.first( con2 );

    test.identical( con.errorsCount(), 0 );
    test.identical( con.argumentsCount(), 0 );
    test.identical( con2.errorsCount(), 0 );
    test.identical( con2.argumentsCount(), 1 );

    con.finally( function( err, got )
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 0 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );

      test.identical( err, undefined );
      test.identical( got, testMsg );

      return got;
    });

    return _.timeOut( 5, function()
    {

      test.identical( con.errorsCount(), 0 );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con2.errorsCount(), 0 );
      test.identical( con2.argumentsCount(), 1 );

      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 1 );
      test.identical( con2.resourcesGet().length, 1 );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passed consequence shares own resource with timeout';
    var con = new _.Consequence();
    var con2 = _.timeOut( 250, () => testMsg );
    var timeBefore = _.timeNow();
    con.first( con2 );
    con.got( function( err, got )
    {
      var delay = _.timeNow() - timeBefore;
      var description = test.case = 'delay ' + delay;
      test.ge( delay, 250 - c.timeAccuracy );
      test.case = description;
      test.identical( err, undefined );
      test.identical( got, testMsg );
    })
    return _.timeOut( 251, function()
    {
      test.identical( con.competitorsEarlyGet().length, 0 );
      test.identical( con.resourcesGet().length, 0 );
      test.identical( con2.resourcesGet().length, 1 );
      return null;
    })
  });

  /* */

  que.finally( () =>
  {
    test.close( 'AsyncCompetitorHanding : 1, AsyncResourceAdding : 1' );
    _.Consequence.AsyncModeSet( amode );
    return null;
  });

  return que;
}

first.timeOut = 20000;

//

function from( test )
{
  var testMsg = 'value';
  var que = new _.Consequence().take( null )

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passing value';
    var con = _.Consequence.From( testMsg );
    test.identical( con.resourcesGet(), [ { error : undefined, argument : testMsg } ] );
    test.identical( con.competitorsEarlyGet(), [] );
    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passing an error';
    var err = _.err( testMsg );
    var con = _.Consequence.From( err );
    test.identical( con.resourcesGet(), [ { error : err, argument : undefined } ] );
    test.identical( con.competitorsEarlyGet(), [] );
    return con.finally( () => null );
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passing consequence';
    var src = new _.Consequence().take( testMsg );
    var con = _.Consequence.From( src );
    test.identical( con, src );
    test.identical( con.resourcesGet(), [ { error : undefined, argument : testMsg } ] );
    test.identical( con.competitorsEarlyGet(), [] );
    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passing resolved promise';
    var src = Promise.resolve( testMsg );
    var con = _.Consequence.From( src );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet(), [ { error : undefined, argument : testMsg } ] );
      test.identical( con.competitorsEarlyGet(), [] );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passing rejected promise';
    var src = Promise.reject( testMsg );
    var con = _.Consequence.From( src );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet(), [ { error : testMsg, argument : undefined } ] );
      test.identical( con.competitorsEarlyGet(), [] );
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    wConsequence.prototype.AsyncCompetitorHanding = 0;
    wConsequence.prototype.AsyncResourceAdding = 1;
    return null;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'async resources adding passing value';
    var con = _.Consequence.From( testMsg );
    test.identical( con.resourcesGet(), [ { error : undefined, argument : testMsg } ] );
    con.got( ( err, got ) => test.identical( got, testMsg ) );
    test.identical( con.resourcesGet(), [] );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet(), [] );
      test.identical( con.competitorsEarlyGet(), [] );
      return null;
    })

    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passing an error';
    var src = _.err( testMsg );
    var con = _.Consequence.From( src );
    test.identical( con.resourcesGet(), [ { error : src, argument : undefined } ] );
    con.got( ( err, got ) => test.identical( err, src ) )
    test.identical( con.resourcesGet(), [] );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet(), [] );
      test.identical( con.competitorsEarlyGet(), [] );
      return null;
    })

    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passing consequence';
    var src = new _.Consequence().take( testMsg );
    var con = _.Consequence.From( src );
    test.identical( src.resourcesGet(), [ { error : undefined, argument : testMsg } ] );
    con.got( ( err, got ) => test.identical( got, testMsg ) );
    test.identical( src.resourcesGet(), [] );
    test.identical( con, src );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet(), [] );
      test.identical( con.competitorsEarlyGet(), [] );
      return null;
    })

    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passing resolved promise';
    var src = Promise.resolve( testMsg );
    var con = _.Consequence.From( src );
    con.got( ( err, got ) => test.identical( got, testMsg ) );
    test.identical( con.resourcesGet().length, 0 )
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 0 )
      test.identical( con.competitorsEarlyGet().length, 0 )
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'passing rejected promise';
    var src = Promise.reject( testMsg );
    var con = _.Consequence.From( src );
    con.got( ( err, got ) => test.identical( err, testMsg ) );
    test.identical( con.resourcesGet().length, 0 )
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 0 )
      test.identical( con.competitorsEarlyGet().length, 0 )
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    wConsequence.prototype.AsyncCompetitorHanding = 1;
    wConsequence.prototype.AsyncResourceAdding = 0;
    return null;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding, passing value';
    var con = _.Consequence.From( testMsg );
    con.got( ( err, got ) => test.identical( got, testMsg ) )
    test.identical( con.resourcesGet(), [ { error : undefined, argument : testMsg } ] );
    test.identical( con.competitorsEarlyGet().length, 1 );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet(), [] );
      test.identical( con.competitorsEarlyGet(), [] );
      return null;
    })

    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding,passing an error';
    var src = _.err( testMsg );
    var con = _.Consequence.From( src );
    con.got( ( err, got ) => test.identical( err, src ) )
    test.identical( con.resourcesGet(), [ { error : src, argument : undefined } ] );
    test.identical( con.competitorsEarlyGet().length, 1 );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet(), [] );
      test.identical( con.competitorsEarlyGet(), [] );
      return null;
    })

    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding,passing consequence';
    var src = new _.Consequence().take( testMsg );
    var con = _.Consequence.From( src );
    con.got( ( err, got ) => test.identical( got, testMsg ) );
    test.identical( src.resourcesGet(), [ { error : undefined, argument : testMsg } ] );
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con, src );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet(), [] );
      test.identical( con.competitorsEarlyGet(), [] );
      return null;
    })

    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding,passing resolved promise';
    var src = Promise.resolve( testMsg );
    var con = _.Consequence.From( src );
    con.got( ( err, got ) => test.identical( got, testMsg ) );
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 )
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 0 )
      test.identical( con.competitorsEarlyGet().length, 0 )
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'async competitors adding,passing rejected promise';
    var src = Promise.reject( testMsg );
    var con = _.Consequence.From( src );
    con.got( ( err, got ) => test.identical( err, testMsg ) );
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 )
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 0 )
      test.identical( con.competitorsEarlyGet().length, 0 )
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    wConsequence.prototype.AsyncCompetitorHanding = 1;
    wConsequence.prototype.AsyncResourceAdding = 1;
    return null;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'async, passing value';
    var con = _.Consequence.From( testMsg );
    con.got( ( err, got ) => test.identical( got, testMsg ) )
    test.identical( con.resourcesGet(), [ { error : undefined, argument : testMsg } ] );
    test.identical( con.competitorsEarlyGet().length, 1 );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet(), [] );
      test.identical( con.competitorsEarlyGet(), [] );
      return null;
    })

    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'async,passing an error';
    var src = _.err( testMsg );
    var con = _.Consequence.From( src );
    con.got( ( err, got ) => test.identical( err, src ) )
    test.identical( con.resourcesGet(), [ { error : src, argument : undefined } ] );
    test.identical( con.competitorsEarlyGet().length, 1 );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet(), [] );
      test.identical( con.competitorsEarlyGet(), [] );
      return null;
    })

    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'async,passing consequence';
    var src = new _.Consequence().take( testMsg );
    var con = _.Consequence.From( src );
    con.got( ( err, got ) => test.identical( got, testMsg ) );
    test.identical( src.resourcesGet(), [ { error : undefined, argument : testMsg } ] );
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con, src );
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet(), [] );
      test.identical( con.competitorsEarlyGet(), [] );
      return null;
    })

    return con;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'async,passing resolved promise';
    var src = Promise.resolve( testMsg );
    var con = _.Consequence.From( src );
    con.got( ( err, got ) => test.identical( got, testMsg ) );
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 )
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 0 )
      test.identical( con.competitorsEarlyGet().length, 0 )
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'async,passing rejected promise';
    var src = Promise.reject( testMsg );
    var con = _.Consequence.From( src );
    con.got( ( err, got ) => test.identical( err, testMsg ) );
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 )
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 0 )
      test.identical( con.competitorsEarlyGet().length, 0 )
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    wConsequence.prototype.AsyncCompetitorHanding = 0;
    wConsequence.prototype.AsyncResourceAdding = 0;
    return null;
  })
  .keep/*finally*/( function( arg )
  {
    test.case = 'sync, resolved promise, timeout';
    var src = Promise.resolve( testMsg );
    var con = _.Consequence.From( src, 500 );
    con.got( ( err, got ) => test.identical( got, testMsg ) );
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 )
    return _.timeOut( 1, function()
    {
      test.identical( con.resourcesGet().length, 0 )
      test.identical( con.competitorsEarlyGet().length, 0 )
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'sync, promise resolved with timeout';
    var src = new Promise( ( resolve ) =>
    {
      setTimeout( () => resolve( testMsg ), 600 );
    })
    var con = _.Consequence.From( src, 500 );
    con.got( ( err, got ) => test.is( _.errIs( err ) ) );
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 )
    return _.timeOut( 600, function()
    {
      test.identical( con.resourcesGet().length, 0 )
      test.identical( con.competitorsEarlyGet().length, 0 )
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'sync, timeout, src is a consequence';
    var con = new _.Consequence().take( testMsg );
    con = _.Consequence.From( con , 500 );
    con.got( ( err, got ) => test.identical( got, testMsg ) );
    test.identical( con.competitorsEarlyGet().length, 0 );
    test.identical( con.resourcesGet().length, 0 );
    return null;
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    test.case = 'sync, timeout, src is a consequence';
    var con = _.timeOut( 600, () => testMsg );
    con = _.Consequence.From( con , 500 );
    con.got( ( err, got ) => test.is( _.errIs( err ) ) );
    test.identical( con.competitorsEarlyGet().length, 1 );
    test.identical( con.resourcesGet().length, 0 );
    return _.timeOut( 600, function()
    {
      test.identical( con.resourcesGet().length, 0 )
      test.identical( con.competitorsEarlyGet().length, 0 )
      return null;
    })
  })

  /**/

  .keep/*finally*/( function( arg )
  {
    wConsequence.prototype.AsyncCompetitorHanding = 0;
    wConsequence.prototype.AsyncResourceAdding = 0;
    return null;
  })

  return que;
}

//

function consequenceLike( test )
{
  test.case = 'check if entity is a consequenceLike';

  if( !_.consequenceLike )
  return test.identical( true,true );

  test.is( !_.consequenceLike() );
  test.is( !_.consequenceLike( {} ) );
  if( _.Consequence )
  {
    test.is( _.consequenceLike( new _.Consequence() ) );
    test.is( _.consequenceLike( _.Consequence() ) );
  }
  test.is( _.consequenceLike( Promise.resolve( 0 ) ) );

  var promise = new Promise( ( resolve, reject ) => { resolve( 0 ) } )
  test.is( _.consequenceLike( promise ) );
  test.is( _.consequenceLike( _.Consequence.From( promise ) ) );

}

//

function competitorCancel( test )
{
  var con = new _.Consequence().take( null );

  function competitor1(){}
  function competitor2(){}

  test.case = 'setup';

  con.got( competitor1 );
  con.got( competitor1 );
  con.got( competitor2 );

  test.identical( con.argumentsCount(), 0 );
  test.identical( con.errorsCount(), 0 );
  test.identical( con.competitorsCount(), 2 );

  test.case = 'cancel comeptitor2';

  con.competitorCancel( competitor2 );

  if( Config.debug )
  test.shouldThrowErrorSync( () => con.competitorCancel( competitor2 ) );

  test.identical( con.argumentsCount(), 0 );
  test.identical( con.errorsCount(), 0 );
  test.identical( con.competitorsCount(), 1 );

  test.case = 'cancel comeptitor1';

  con.competitorCancel( competitor1 );
  if( Config.debug )
  test.shouldThrowErrorSync( () => con.competitorCancel( competitor1 ) );

  test.identical( con.argumentsCount(), 0 );
  test.identical( con.errorsCount(), 0 );
  test.identical( con.competitorsCount(), 0 );

  if( !Config.debug )
  return;

  test.case = 'throwing';

  test.shouldThrowErrorSync( () => con.competitorCancel( competitor1 ) );
  test.shouldThrowErrorSync( () => con.competitorCancel( competitor2 ) );
  test.shouldThrowErrorSync( () => con.competitorCancel() );
  test.shouldThrowErrorSync( () => con.competitorCancel( null ) );
  test.shouldThrowErrorSync( () => con.competitorCancel( 1 ) );
  test.shouldThrowErrorSync( () => con.competitorCancel( '1' ) );

}

//

function competitorsCancel( test )
{
  var con = new _.Consequence().take( null );

  function competitor1(){};
  function competitor2(){};

  con.got( competitor1 );
  con.got( competitor1 );
  con.got( competitor1 );
  con.got( competitor2 );

  test.case = 'setup';

  test.identical( con.argumentsCount(), 0 );
  test.identical( con.errorsCount(), 0 );
  test.identical( con.competitorsCount(), 3 );

  test.case = 'cancel competitor2';

  con.competitorsCancel( competitor2 );

  test.identical( con.argumentsCount(), 0 );
  test.identical( con.errorsCount(), 0 );
  test.identical( con.competitorsCount(), 2 );

  test.case = 'cancel competitor2, none found';

  con.competitorsCancel( competitor2 );

  test.identical( con.argumentsCount(), 0 );
  test.identical( con.errorsCount(), 0 );
  test.identical( con.competitorsCount(), 2 );

  test.case = 'cancel several competitor1';

  con.competitorsCancel( competitor1 );

  test.identical( con.argumentsCount(), 0 );
  test.identical( con.errorsCount(), 0 );
  test.identical( con.competitorsCount(), 0 );

  test.case = 'cancel competitor1, none found';

  con.competitorsCancel( competitor1 );

  test.identical( con.argumentsCount(), 0 );
  test.identical( con.errorsCount(), 0 );
  test.identical( con.competitorsCount(), 0 );

  test.case = 'cancel all, none found';

  con.competitorsCancel()

  test.identical( con.argumentsCount(), 0 );
  test.identical( con.errorsCount(), 0 );
  test.identical( con.competitorsCount(), 0 );

  test.case = 'cancel all';

  con.got( competitor1 );
  con.got( competitor1 );
  con.got( competitor1 );
  con.got( competitor2 );

  test.identical( con.argumentsCount(), 0 );
  test.identical( con.errorsCount(), 0 );
  test.identical( con.competitorsCount(), 4 );

  con.competitorsCancel()

  test.identical( con.argumentsCount(), 0 );
  test.identical( con.errorsCount(), 0 );
  test.identical( con.competitorsCount(), 0 );

  if( !Config.debug )
  return;

  test.case = 'throwing';

  test.shouldThrowErrorSync( () => con.competitorsCancel( null ) );
  test.shouldThrowErrorSync( () => con.competitorsCancel( 1 ) );
  test.shouldThrowErrorSync( () => con.competitorsCancel( '1' ) );

}

//

function Take( test )
{
  function routine( err, arg )
  {
    return [ err, arg ];
  }

  test.case = 'routine, single arg';
  var got = _.Consequence.Take( routine, true );
  test.identical( got, [ undefined, true ] );

  test.case = 'routine, single arg';
  var err = _.err('err');
  var got = _.Consequence.Take( routine, err, undefined );
  test.identical( got, [ err, undefined ] );

  test.case = 'routine, two args';
  var err = _.err('err');
  var got = _.Consequence.Take( routine, err, true );
  test.identical( got, [ err, true ] );

  let mainCon = new _.Consequence().take( null )

  .thenKeep( () =>
  {
    test.case = 'consequence, single arg';
    let con = new _.Consequence().finally( routine );
    con.thenKeep( ( got ) => test.identical( got, [ undefined, true ] ) )
    _.Consequence.Take( con, true );
    return con;
  })

  .thenKeep( () =>
  {
    test.case = 'consequence, single arg';
    var err = _.err('err');
    let con = new _.Consequence().finally( routine );
    con.thenKeep( ( got ) => test.identical( got, [ err, undefined ] ) )
    _.Consequence.Take( con, err, undefined );
    return con;
  })

  .thenKeep( () =>
  {
    test.case = 'several consequences';
    var cons =
    [
      new _.Consequence().finally( routine ),
      new _.Consequence().finally( routine ),
      new _.Consequence().finally( routine )
    ]
    let con = new _.Consequence().take( null ).andKeep( cons );
    let expected =
    [
      [ undefined, true ],
      [ undefined, true ],
      [ undefined, true ]
    ]
    con.thenKeep( ( got ) => test.contains( got, expected ) );
    _.Consequence.Take( cons, true );
    return con;
  })

  .thenKeep( () =>
  {
    test.case = 'several consequences and routine';
    let con = new _.Consequence().take( null );
    let routineResult;
    function routine2( err, arg )
    {
      routineResult = [ err, arg ];
    }
    let cons =
    [
      new _.Consequence().finally( routine ),
      new _.Consequence().finally( routine ),
      routine2
    ]
    let expected =
    [
      [ undefined, true ],
      [ undefined, true ],
    ]
    con.andKeep( cons.slice( 0, 2 ) );
    con.thenKeep( ( got ) =>
    {
      test.contains( got, expected );
      test.identical( routineResult,[ undefined, true ] );
      return true;
    });
    _.Consequence.Take( cons, true );
    return con;
  })

  .thenKeep( () =>
  {
    test.case = 'consequence, two args';
    var err = _.err('err');
    let con = new _.Consequence().finally( routine );
    con.thenKeep( ( got ) => test.identical( got, [ err, true ] ) )
    return test.shouldThrowError( () => _.Consequence.Take( con, err, true ) );
  })

  return mainCon;
}

// --
// declare
// --

var Self =
{

  name : 'Tools/base/Consequence',
  silencing : 1,
  // verbosity : 7,

  context :
  {
    timeAccuracy : 1,
  },

  tests :
  {

    trivial,
    ordinarMessage,

    finallyPromiseGive,

    _finally,
    finallyPromiseKeep,

    // // _onceGot,
    // // _onceThen,

    split,
    tap,
    tapHandling,

    ifNoErrorGotTrivial,
    ifNoErrorGotThrowing,
    keep,
    except,

    //deasync

    finallyDeasyncGive,
    deasync,
    thenDeasyncGive,
    thenDeasyncKeep,
    exceptDeasyncGive,
    exceptDeasyncKeep,

    timeOut,

    andKeepRoutinesTakeFirst,
    andKeepRoutinesTakeLast,
    andKeepRoutinesDelayed,
    andKeep,
    andTake,
    _and,

    orKeeping,
    orTaking,
    thenOrKeepingNotFiring,
    thenOrKeeping,
    thenOrTaking,

    inter,
    concurrentTakeExperiment,

    first,
    from,
    consequenceLike,

    competitorCancel,
    competitorsCancel,

    Take

  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();