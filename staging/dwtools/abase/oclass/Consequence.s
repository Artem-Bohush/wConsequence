( function _Consequence_s_() {

'use strict';

  /**
   * @file Consequence.s - Advanced synchronization mechanism. wConsequence is able to solve any asynchronous problem
     replacing and including functionality of many other mechanisms, such as: Callback, Event, Signal, Mutex, Semaphore,
     Async, Promise.
   */

/*

 !!! move promise / event property from object to correspondent

 !!! test difference :

    if( err )
    return new _.Consequence().error( err );

    if( err )
    throw _.err( err );

*/

/*

chainer :

1. ignore / use returned
2. append / prepend returned
3.

*/

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      require.resolve( toolsPath )/*hhh*/;
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath )/*hhh*/;
  }

  var _ = _global_.wTools;

  _.include( 'wProto' );
  _.include( 'wCopyable' );

}

var _ = _global_.wTools;

if( _globalReal_.wConsequence )
{
  var Self = _globalReal_.wConsequence;
  _[ Self.nameShort ] = Self;
  if( typeof module !== 'undefined' && module !== null )
  module[ 'exports' ] = Self;
  return;
}

if( _global_.wConsequence )
throw _.err( 'Consequence included several times' );

//

/**
 * Class wConsequence creates objects that used for asynchronous computations. It represent the queue of results that
 * can computation asynchronously, and has a wide range of tools to implement this process.
 * @class wConsequence
 */

/**
 * Function that accepts result of wConsequence value computation. Used as parameter in methods such as got(), doThen(),
  etc.
 * @param {*} err Error object, or any other type, that represent or describe an error reason. If during resolving
    value no exception occurred, it will be set to null;
   @param {*} value resolved by wConsequence value;
 * @callback wConsequence~Correspondent
 */

/**
 * Creates instance of wConsequence
 * @example
   var con = new _.Consequence();
   con.give( 'hello' ).got( function( err, value) { console.log( value ); } ); // hello

   var con = _.Consequence();
   con.got( function( err, value) { console.log( value ); } ).give('world'); // world
 * @param {Object|Function|wConsequence} [o] initialization options
 * @returns {wConsequence}
 * @constructor
 * @see {@link wConsequence}
 */

var Parent = null;

/* heavy optimization */

class wConsequence extends _.CallableObject
{
  constructor()
  {
    var self = super();
    Self.prototype.init.apply( self,arguments );
    return self;
  }
}

var wConsequenceProxy = new Proxy( wConsequence,
{
  apply( original, context, args )
  {
    return new original( ...args );
  }
});

var Parent = null;
var Self = wConsequenceProxy;

wConsequence.nameShort = 'Consequence';

//

/**
 * Initialises instance of wConsequence
 * @param {Object|Function|wConsequence} [o] initialization options
 * @private
 * @method pathCurrent
 * @memberof wConsequence#
 */

function init( o )
{
  var self = this;

  self.messageCounter = 0;
  self._correspondentEarly = [];
  self._correspondentLate = [];
  self._message = [];

  if( Config.debug )
  {
    self.tag = self.Composes.tag;
    self.debug = self.Composes.debug;
    self.limitNumberOfMessages = self.Composes.limitNumberOfMessages;
    self.dependsOf = [];
  }

  Object.preventExtensions( self );

  if( o )
  {
    if( !Config.debug )
    {
      delete o.tag;
      delete o.debug;
      delete o.limitNumberOfMessages;
    }
    self.copy( o );
  }

}

// --
// chainer
// --

/**
 * Method appends resolved value and error handler to wConsequence correspondents sequence. That handler accept only one
    value or error reason only once, and don't pass result of it computation to next handler (unlike Promise 'then').
    if got() called without argument, an empty handler will be appended.
    After invocation, correspondent will be removed from correspondents queue.
    Returns current wConsequence instance.
 * @example
     function gotHandler1( error, value )
     {
       console.log( 'handler 1: ' + value );
     };

     function gotHandler2( error, value )
     {
       console.log( 'handler 2: ' + value );
     };

     var con1 = new _.Consequence();

     con1.got( gotHandler1 );
     con1.give( 'hello' ).give( 'world' );

     // prints only " handler 1: hello ",

     var con2 = new _.Consequence();

     con2.got( gotHandler1 ).got( gotHandler2 );
     con2.give( 'foo' );

     // prints only " handler 1: foo "

     var con3 = new _.Consequence();

     con3.got( gotHandler1 ).got( gotHandler2 );
     con3.give( 'bar' ).give( 'baz' );

     // prints
     // handler 1: bar
     // handler 2: baz
     //
 * @param {wConsequence~Correspondent|wConsequence} [correspondent] callback, that accepts resolved value or exception reason.
 * @returns {wConsequence}
 * @see {@link wConsequence~Correspondent} correspondent callback
 * @throws {Error} if passed more than one argument.
 * @method got
 * @memberof wConsequence#
 */

function got( correspondent )
{
  var self = this;
  var times = 1;

  _.assert( arguments.length === 1,'got : expects none or single argument, got',arguments.length );

  if( _.numberIs( correspondent ) )
  {
    times = correspondent;
    correspondent = function(){};
  }

  return self.__correspondentAppend
  ({
    correspondent : correspondent,
    thenning : false,
    kindOfArguments : Self.KindOfArguments.Both,
    times : times,
    early : true,
  });

}

got.having =
{
  consequizing : 1,
}

//

function lateGot( correspondent )
{
  var self = this;
  var times = 1;

  _.assert( arguments.length === 1,'lateGot : expects none or single argument, lateGot',arguments.length );

  if( _.numberIs( correspondent ) )
  {
    times = correspondent;
    correspondent = function(){};
  }

  return self.__correspondentAppend
  ({
    correspondent : correspondent,
    thenning : false,
    kindOfArguments : Self.KindOfArguments.Both,
    times : times,
    early : false,
  });

}

lateGot.having =
{
  consequizing : 1,
}

//

function promiseGot()
{
  var self = this;

  return new Promise( function( resolve, reject )
  {
    self.got( function( err, got )
    {
      if( err )
      reject( err );
      else
      resolve( got );
    })
  });

}

promiseGot.having =
{
  consequizing : 1,
}

//

/**
 * Method accepts handler for resolved value/error. This handler method doThen adds to wConsequence correspondents sequence.
    After processing accepted value, correspondent return value will be pass to the next handler in correspondents queue.
    Returns current wConsequence instance.

 * @example
   function gotHandler1( error, value )
   {
     console.log( 'handler 1: ' + value );
     value++;
     return value;
   };

   function gotHandler3( error, value )
   {
     console.log( 'handler 3: ' + value );
   };

   var con1 = new _.Consequence();

   con1.doThen( gotHandler1 ).doThen( gotHandler1 ).got(gotHandler3);
   con1.give( 4 ).give( 10 );

   // prints:
   // handler 1: 4
   // handler 1: 5
   // handler 3: 6

 * @param {wConsequence~Correspondent|wConsequence} correspondent callback, that accepts resolved value or exception reason.
 * @returns {wConsequence}
 * @throws {Error} if missed correspondent.
 * @throws {Error} if passed more than one argument.
 * @see {@link wConsequence~Correspondent} correspondent callback
 * @see {@link wConsequence#got} got method
 * @method doThen
 * @memberof wConsequence#
 */

function doThen( correspondent )
{
  var self = this;

  _.assert( arguments.length === 1 );

  return self.__correspondentAppend
  ({
    correspondent : correspondent,
    thenning : true,
    kindOfArguments : Self.KindOfArguments.Both,
    early : true,
  });

}

doThen.having =
{
  consequizing : 1,
}

//

function _doThen( correspondent )
{
  var self = this;

  _.assert( arguments.length === 1 );

  return self.__correspondentAppend
  ({
    correspondent : correspondent,
    thenning : true,
    kindOfArguments : Self.KindOfArguments.BothWithCorrespondent,
    early : true,
  });

}

//

function lateThen( correspondent )
{
  var self = this;

  _.assert( arguments.length === 1 );

  return self.__correspondentAppend
  ({
    correspondent : correspondent,
    thenning : true,
    kindOfArguments : Self.KindOfArguments.Both,
    early : false,
  });

}

lateThen.having =
{
  consequizing : 1,
}

//

function promiseThen()
{
  var self = this;

  return new Promise( function( resolve, reject )
  {
    self.got( function( err, got )
    {
      self.give( err, got );

      if( err )
      reject( err );
      else
      resolve( got );
    });
  });

}

promiseThen.having =
{
  consequizing : 1,
}

//

// /**
//  * Adds to the wConsequences corespondents queue `correspondent` with sealed `context` and `args`. The result of
//  * correspondent will be added to wConsequence message sequence after handling.
//  * Returns current wConsequence instance.
//  * @param {Object} context context that seals for correspondent callback
//  * @param {Function} correspondent callback
//  * @param {Array<*>} [args] arguments arguments that seals for correspondent callback
//  * @returns {wConsequence}
//  * @method thenSealed
//  * @memberof wConsequence#
//  */

// function thenSealed( context,correspondent,args )
// {
//   var self = this;
//
//   _.assert( arguments.length === 2 || arguments.length === 3 );
//
//   if( arguments.length === 2 )
//   if( _.arrayLike( arguments[ 1 ] ) )
//   {
//     args = arguments[ 1 ];
//     correspondent = arguments[ 0 ];
//     context = undefined;
//   }
//
//   var correspondentJoined = _.routineSeal( context,correspondent,args );
//
//   debugger;
//   return self.__correspondentAppend
//   ({
//     correspondent : correspondentJoined,
//     ifNoError : true,
//     thenning : true,
//     early : true,
//   });
//
// }

//

function choke( times )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( times !== undefined )
  {
    _.assert( _.numberIsFinite( times ) );
    for( var t = 0 ; t < times ; t++ )
    self.__correspondentAppend
    ({
      correspondent : function(){},
      thenning : false,
      kindOfArguments : Self.KindOfArguments.Both,
      early : true,
    });
  }
  else
  {
    self.__correspondentAppend
    ({
      correspondent : function(){},
      thenning : false,
      kindOfArguments : Self.KindOfArguments.Both,
      early : true,
    });
  }

  return self;
}

choke.having =
{
  consequizing : 1,
}

//

function chokeThen()
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( times !== undefined )
  {
    _.assert( _.numberIsFinite( times ) );
    for( var t = 0 ; t < times ; t++ )
    self.__correspondentAppend
    ({
      correspondent : function(){},
      thenning : true,
      kindOfArguments : Self.KindOfArguments.Both,
      early : true,
    });
  }
  else
  {
    self.__correspondentAppend
    ({
      correspondent : function(){},
      thenning : true,
      kindOfArguments : Self.KindOfArguments.Both,
      early : true,
    });
  }

  return self;
}

chokeThen.having =
{
  consequizing : 1,
}

//

/**
 * Works like got() method, but adds correspondent to queue only if function with same id not exist in queue yet.
 * Note: this is experimental tool.
 * @example
 *

   function gotHandler1( error, value )
   {
     console.log( 'handler 1: ' + value );
   };

   function gotHandler2( error, value )
   {
     console.log( 'handler 2: ' + value );
   };

   var con1 = new _.Consequence();

   con1._onceGot( gotHandler1 )._onceGot( gotHandler1 )._onceGot( gotHandler2 );
   con1.give( 'foo' ).give( 'bar' );

   // logs:
   // handler 1: foo
   // handler 2: bar
   // correspondent gotHandler1 has ben invoked only once, because second correspondent was not added to correspondents queue.

   // but:

   var con2 = new _.Consequence();

   con2.give( 'foo' ).give( 'bar' ).give('baz');
   con2._onceGot( gotHandler1 )._onceGot( gotHandler1 )._onceGot( gotHandler2 );

   // logs:
   // handler 1: foo
   // handler 1: bar
   // handler 2: baz
   // in this case first gotHandler1 has been removed from correspondents queue immediately after the invocation, so adding
   // second gotHandler1 is legitimate.

 *
 * @param {wConsequence~Correspondent|wConsequence} correspondent callback, that accepts resolved value or exception reason.
 * @returns {wConsequence}
 * @throws {Error} if passed more than one argument.
 * @throws {Error} if correspondent.id is not string.
 * @see {@link wConsequence~Correspondent} correspondent callback
 * @see {@link wConsequence#got} got method
 * @method _onceGot
 * @memberof wConsequence#
 */

function _onceGot( correspondent )
{
  var self = this;
  var key = correspondent.name ? correspondent.name : correspondent;

  _.assert( _.strIsNotEmpty( key ) );
  _.assert( arguments.length === 1 );

  var i = _.arrayLeftIndexOf( self._correspondentEarly,key,function( a )
  {
    return a.id || correspondent.name;
    // return a.id || a.onGot.name;
  });

  if( i >= 0 )
  return self;

  var i = _.arrayLeftIndexOf( self._correspondentLate,key,function( a )
  {
    return a.id || correspondent.name;
    // return a.id || a.onGot.name;
  });

  if( i >= 0 )
  return self;

  return self.__correspondentAppend
  ({
    correspondent : correspondent,
    thenning : false,
    kindOfArguments : Self.KindOfArguments.Both,
    early : true,
  });
}

//

/**
 * Works like doThen() method, but adds correspondent to queue only if function with same id not exist in queue yet.
 * Note: this is an experimental tool.
 *
 * @example
   function gotHandler1( error, value )
   {
     console.log( 'handler 1: ' + value );
     value++;
     return value;
   };

   function gotHandler2( error, value )
   {
     console.log( 'handler 2: ' + value );
   };

   function gotHandler3( error, value )
   {
     console.log( 'handler 3: ' + value );
   };

   var con1 = new _.Consequence();

   con1._onceThen( gotHandler1 )._onceThen( gotHandler1 ).got(gotHandler3);
   con1.give( 4 ).give( 10 );

   // prints
   // handler 1: 4
   // handler 3: 5

 * @param {wConsequence~Correspondent|wConsequence} correspondent callback, that accepts resolved value or exception
   reason.
 * @returns {*}
 * @throws {Error} if passed more than one argument.
 * @throws {Error} if correspondent is defined as anonymous function including anonymous function expression.
 * @see {@link wConsequence~Correspondent} correspondent callback
 * @see {@link wConsequence#doThen} doThen method
 * @see {@link wConsequence#_onceGot} _onceGot method
 * @method _onceThen
 * @memberof wConsequence#
 */

function _onceThen( correspondent )
{
  var self = this;
  var key = correspondent.name ? correspondent.name : correspondent;

  _.assert( _.strIsNotEmpty( key ) );
  _.assert( arguments.length === 1 );

  var i = _.arrayLeftIndexOf( self._correspondentEarly,key,function( a )
  {
    return a.id;
    // return a.id || a.onGot.name;
  });

  if( i >= 0 )
  {
    debugger;
    return self;
  }

  var i = _.arrayLeftIndexOf( self._correspondentLate,key,function( a )
  {
    return a.id;
    // return a.id || a.onGot.name;
  });

  if( i >= 0 )
  {
    debugger;
    return self;
  }

  return self.__correspondentAppend
  ({
    correspondent : correspondent,
    thenning : true,
    kindOfArguments : Self.KindOfArguments.Both,
    early : true,
  });
}

//

/**
 * Returns new wConsequence instance. If on cloning moment current wConsequence has unhandled resolved values in queue
   the first of them would be handled by new wConsequence. Else pass accepted
 * @example
   function gotHandler1( error, value )
   {
     console.log( 'handler 1: ' + value );
     value++;
     return value;
   };

   function gotHandler2( error, value )
   {
     console.log( 'handler 2: ' + value );
   };

   var con1 = new _.Consequence();
   con1.give(1).give(2).give(3);
   var con2 = con1.split();
   con2.got( gotHandler2 );
   con2.got( gotHandler2 );
   con1.got( gotHandler1 );
   con1.got( gotHandler1 );

    // prints:
    // handler 2: 1 // only first value copied into cloned wConsequence
    // handler 1: 1
    // handler 1: 2

 * @returns {wConsequence}
 * @throws {Error} if passed any argument.
 * @method split
 * @memberof wConsequence#
 */

function split( first )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  var result = new Self();

  if( first )
  {
    result.doThen( first );
    self.got( function( err,data )
    {
      result.give( err,data );
      this.give( err,data );
    });
  }
  else
  {
    self.doThen( result );
  }

  return result;
}

split.having =
{
  consequizing : 1,
}

//

/**
 * Works like got() method, but value that accepts correspondent, passes to the next taker in takers queue without
   modification.
 * @example
 *
   function gotHandler1( error, value )
   {
     console.log( 'handler 1: ' + value );
     value++;
     return value;
   }

   function gotHandler2( error, value )
   {
     console.log( 'handler 2: ' + value );
   }

   function gotHandler3( error, value )
   {
     console.log( 'handler 3: ' + value );
   }

   var con1 = new _.Consequence();
   con1.give(1).give(4);

   // prints:
   // handler 1: 1
   // handler 2: 1
   // handler 3: 4

 * @param {wConsequence~Correspondent|wConsequence} correspondent callback, that accepts resolved value or exception
   reason.
 * @returns {wConsequence}
 * @throws {Error} if passed more than one arguments
 * @see {@link wConsequence#got} got method
 * @method tap
 * @memberof wConsequence#
 */

function tap( correspondent )
{
  var self = this;

  _.assert( arguments.length === 1 );

  return self.__correspondentAppend
  ({
    correspondent : correspondent,
    thenning : false,
    tapping : true,
    kindOfArguments : Self.KindOfArguments.Both,
    early : true,
  });

}

tap.having =
{
  consequizing : 1,
}

//

function ifNoErrorGot()
{
  var self = this;

  _.assert( arguments.length === 1 );

  return self.__correspondentAppend
  ({
    correspondent : arguments[ 0 ],
    thenning : false,
    kindOfArguments : Self.KindOfArguments.IfNoError,
    early : true,
  });

}

ifNoErrorGot.having =
{
  consequizing : 1,
}

//

/**
 * Method pushed `correspondent` callback into wConsequence correspondents queue. That callback will
   trigger only in that case if accepted error parameter will be null. Else accepted error will be passed to the next
   correspondent in queue. After handling accepted value, correspondent pass result to the next handler, like doThen
   method.
 * @returns {wConsequence}
 * @throws {Error} if passed more than one arguments
 * @see {@link wConsequence#got} doThen method
 * @method ifNoErrorThen
 * @memberof wConsequence#
 */

function ifNoErrorThen()
{
  var self = this;

  _.assert( arguments.length === 1 );

  return self.__correspondentAppend
  ({
    correspondent : arguments[ 0 ],
    thenning : true,
    kindOfArguments : Self.KindOfArguments.IfNoError,
    early : true,
  });

}

ifNoErrorThen.having =
{
  consequizing : 1,
}

//

function ifErrorGot()
{
  var self = this;

  _.assert( arguments.length === 1 );

  return self.__correspondentAppend
  ({
    correspondent : arguments[ 0 ],
    thenning : false,
    kindOfArguments : Self.KindOfArguments.IfError,
    early : true,
  });

}

ifErrorGot.having =
{
  consequizing : 1,
}

//

/**
 * ifErrorThen method pushed `correspondent` callback into wConsequence correspondents queue. That callback will
   trigger only in that case if accepted error parameter will be defined and not null. Else accepted parameters will
   be passed to the next correspondent in queue.
 * @example
 *
   function gotHandler1( error, value )
   {
     console.log( 'handler 1: ' + value );
     value++;
     return value;
   }

   function gotHandler3( error, value )
   {
     console.log( 'handler 3 err: ' + error );
     console.log( 'handler 3 val: ' + value );
   }

   var con2 = new _.Consequence();

   con2._giveWithError( 'error msg', 8 ).give( 14 );
   con2.ifErrorThen( gotHandler3 ).got( gotHandler1 );

   // prints:
   // handler 3 err: error msg
   // handler 3 val: 8
   // handler 1: 14

 * @param {wConsequence~Correspondent|wConsequence} correspondent callback, that accepts exception  reason and value .
 * @returns {wConsequence}
 * @throws {Error} if passed more than one arguments
 * @see {@link wConsequence#got} doThen method
 * @method ifErrorThen
 * @memberof wConsequence#
 */

function ifErrorThen()
{
  var self = this;

  _.assert( arguments.length === 1 );

  return self.__correspondentAppend
  ({
    correspondent : arguments[ 0 ],
    thenning : true,
    kindOfArguments : Self.KindOfArguments.IfError,
    early : true,
  });

}

ifErrorThen.having =
{
  consequizing : 1,
}

//

/**
 * Creates and adds to corespondents sequence error handler. If handled message contains error, corespondent logs it.
 * @returns {wConsequence}
 * @throws {Error} If called with any argument.
 * @method ifErrorThenLogThen
 * @memberof wConsequence#
 */

function ifErrorThenLogThen()
{
  var self = this;

  _.assert( arguments.length === 0 );

  function reportError( err )
  {
    throw _.errLogOnce( err );
  }

  return self.__correspondentAppend
  ({
    correspondent : reportError,
    thenning : true,
    kindOfArguments : Self.KindOfArguments.IfError,
    early : true,
  });

}

ifErrorThenLogThen.having =
{
  consequizing : 1,
}

// /**
//  * Using for debugging. Taps into wConsequence correspondents sequence predefined wConsequence correspondent callback, that contains
//     'debugger' statement. If correspondent accepts non null `err` parameter, it generate and throw error based on
//     `err` value. Else passed accepted `value` parameter to the next handler in correspondents sequence.
//  * Note: this is experimental tool.
//  * @returns {wConsequence}
//  * @throws {Error} If try to call method with any argument.
//  * @method debugThen
//  * @memberof wConsequence#
//  */

// function debugThen()
// {
//   var self = this;
//
//   _.assert( arguments.length === 0 );
//
//   return self.__correspondentAppend
//   ({
//     correspondent : _onDebug,
//     thenning : true,
//     early : true,
//   });
//
// }

//

/**
 * Works like doThen, but when correspondent accepts message from messages sequence, execution of correspondent will be
    delayed. The result of correspondent execution will be passed to the handler that is first in correspondent queue
    on execution end moment.

 * @example
 *
   function gotHandler1( error, value )
   {
     console.log( 'handler 1: ' + value );
     value++;
     return value;
   }

   function gotHandler2( error, value )
   {
     console.log( 'handler 2: ' + value );
   }

   var con = new _.Consequence();

   con.timeOutThen(500, gotHandler1).got( gotHandler2 );
   con.give(90);
   //  prints:
   // handler 1: 90
   // handler 2: 91

 * @param {number} time delay in milliseconds
 * @param {wConsequence~Correspondent|wConsequence} correspondent callback, that accepts exception reason and value.
 * @returns {wConsequence}
 * @throws {Error} if missed arguments.
 * @throws {Error} if passed extra arguments.
 * @see {@link wConsequence~doThen} doThen method
 * @method timeOutThen
 * @memberof wConsequence#
 */

function timeOutThen( time,correspondent )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  /* */

  if( !correspondent )
  correspondent = Self.passThru;

  /* */

  var cor;
  if( _.consequenceIs( correspondent ) )
  cor = function __timeOutThen( err,data )
  {
    debugger;
    return _.timeOut( time,function()
    {
      debugger;
      correspondent.__giveAct( err,data );
      if( err )
      throw _.err( err );
      return data;
    });
  }
  else
  cor = function __timeOutThen( err,data )
  {
    return _.timeOut( time,self,correspondent,[ err,data ] );
  }

  /* */

  return self.__correspondentAppend
  ({
    thenning : true,
    correspondent : cor,
    kindOfArguments : Self.KindOfArguments.Both,
    early : true,
  });

}

timeOutThen.having =
{
  consequizing : 1,
}

//

// /**
//  * Correspondents added by persist method, will be accepted every messages resolved by wConsequence, like an event
//     listener. Returns current wConsequence instance.
//  * @example
//    function gotHandler1( error, value )
//    {
//      console.log( 'message handler 1: ' + value );
//      value++;
//      return value;
//    }
//
//    function gotHandler2( error, value )
//    {
//      console.log( 'message handler 2: ' + value );
//    }
//
//    var con = new _.Consequence();
//
//    var messages = [ 'hello', 'world', 'foo', 'bar', 'baz' ],
//    len = messages.length,
//    i = 0;
//
//    con.persist( gotHandler1).persist( gotHandler2 );
//
//    for( ; i < len; i++) con.give( messages[i] );
//
//    // prints:
//    // message handler 1: hello
//    // message handler 2: hello
//    // message handler 1: world
//    // message handler 2: world
//    // message handler 1: foo
//    // message handler 2: foo
//    // message handler 1: bar
//    // message handler 2: bar
//    // message handler 1: baz
//    // message handler 2: baz
//
//  * @param {wConsequence~Correspondent|wConsequence} correspondent callback, that accepts exception reason and value.
//  * @returns {wConsequence}
//  * @throws {Error} if missed arguments.
//  * @throws {Error} if passed extra arguments.
//  * @see {@link wConsequence~got} got method
//  * @method persist
//  * @memberof wConsequence#
//  */
//
// function persist( correspondent )
// {
//   var self = this;
//
//   _.assert( arguments.length === 1 );
//
//   return self.__correspondentAppend
//   ({
//     correspondent : correspondent,
//     thenning : false,
//     persistent : true,
//     kindOfArguments : Self.KindOfArguments.Both,
//   });
//
// }

// --
// advanced
// --

/**
 * Method accepts array of wConsequences object. If current wConsequence instance ready to resolve message, it will be
   wait for all passed wConsequence instances will been resolved, then current wConsequence resolve own message.
   Returns current wConsequence.
 * @example
 *
   function handleGot1(err, val)
   {
     if( err )
     {
       console.log( 'handleGot1 error: ' + err );
     }
     else
     {
       console.log( 'handleGot1 value: ' + val );
     }
   };

   var con1 = new _.Consequence();
   var con2 = new _.Consequence();

   con1.got( function( err, value )
   {
     console.log( 'con1 handler executed with value: ' + value + 'and error: ' + err );
   } );

   con2.got( function( err, value )
   {
     console.log( 'con2 handler executed with value: ' + value + 'and error: ' + err );
   } );

   var conOwner = new  _.Consequence();

   conOwner.andThen( [ con1, con2 ] );

   conOwner.give( 100 );
   conOwner.got( handleGot1 );

   con1.give( 'value1' );
   con2.error( 'ups' );
   // prints
   // con1 handler executed with value: value1and error: null
   // con2 handler executed with value: undefinedand error: ups
   // handleGot1 value: 100

 * @param {wConsequence[]|wConsequence} srcs array of wConsequence
 * @returns {wConsequence}
 * @throws {Error} if missed arguments.
 * @throws {Error} if passed extra arguments.
 * @method andGot
 * @memberof wConsequence#
 */

function andGot( srcs )
{
  var self = this;
  _.assert( arguments.length === 1 );
  return self._and( srcs,false );
}

andGot.having =
{
  consequizing : 1,
}

//

/**
 * Works like andGot() method, but unlike andGot() andThen() give back massages to src consequences once all come.
 * @see wConsequence#andGot
 * @param {wConsequence[]|wConsequence} srcs Array of wConsequence objects
 * @throws {Error} If missed or passed extra argument.
 * @method andThen
 * @memberof wConsequence#
 */

function andThen( srcs )
{
  var self = this;
  _.assert( arguments.length === 1 );
  return self._and( srcs,true );
}

andThen.having =
{
  consequizing : 1,
}

//

function _and( srcs,thenning )
{
  var self = this;
  var returned = [];
  var anyErr;

  if( !_.arrayIs( srcs ) )
  srcs = [ srcs ];
  else
  srcs = srcs.slice();

  srcs.push( self );

  /* */

  function __give()
  {

    if( thenning )
    for( var i = 0 ; i < srcs.length-1 ; i++ )
    if( srcs[ i ] )
    srcs[ i ].give( returned[ i ][ 0 ],returned[ i ][ 1 ] );

    if( anyErr )
    self.error( anyErr );
    else
    self.give( returned[ srcs.length-1 ][ 1 ] );

  }

  /* */

  var count = srcs.length;
  function __got( index,err,data )
  {

    count -= 1;

    if( err && !anyErr )
    anyErr = err;

    returned[ index ] = [ err,data ];

    if( Config.debug )
    if( self.diagnostics )
    if( index < srcs.length-1 )
    if( _.consequenceIs( srcs[ index ] ) )
    {
      // if( _.workerIs() )
      // debugger;
      _.arrayRemoveOnceStrictly( self.dependsOf , srcs[ index ] );
    }

    if( count === 0 )
    _.timeSoon( __give );

  }

  /* */

  // self.got( _.routineJoin( undefined,got,[ srcs.length ] ) );

  /* */

  if( Config.debug )
  if( self.diagnostics )
  {

    for( var s = 0 ; s < srcs.length-1 ; s++ )
    {
      var src = srcs[ s ];
      _.assert( _.consequenceIs( src ) || _.routineIs( src ) || src === null,'and expects consequence, routine or null' );
      if( !_.consequenceIs( src ) )
      continue;
      // if( !src || !src.doesDependOf )
      // debugger;
      // _.assert( !src.doesDependOf( self ),'dead lock!' );
      // _.assert( !src.correspondentHas( self ),'dead lock!' );
      src.assertNoDeadLockWith( self );
      self.dependsOf.push( src );
      // if( _.workerIs() )
      // debugger;
    }

  }

  /* */

  // if( _.workerIs() )
  // debugger;

  self.got( function _andGot( err,data )
  {

    for( var s = 0 ; s < srcs.length-1 ; s++ )
    {
      var src = srcs[ s ];

      if( !_.consequenceIs( src ) && _.routineIs( src ) )
      {
        src = srcs[ s ] = src();
        if( Config.debug )
        if( self.diagnostics )
        self.dependsOf.push( src );
      }

      // debugger;
      if( Config.debug )
      if( self.diagnostics )
      if( _.consequenceIs( srcs[ s ] ) )
      src.assertNoDeadLockWith( self );
      // _.assert( !src.correspondentHas( self ),'dead lock!' );

      _.assert( _.consequenceIs( src ) || src === null,'expects consequence or null, got',_.strTypeOf( src ) );
      if( src === null )
      {
        __got( s,null,null );
        continue;
      }

      var r = _.routineJoin( undefined,__got,[ s ] );
      r.tag = _.numberRandomInt( 100 );
      // if( _.workerIs() )
      // debugger;
      src.got( r );
    }

    __got( srcs.length-1,err,data );

  });

  return self;
}

//

function eitherGot( srcs )
{
  var self = this;
  _.assert( arguments.length === 1 );
  return self._either( srcs,false );
}

eitherGot.having =
{
  consequizing : 1,
}

//

function eitherThen( srcs )
{
  var self = this;
  _.assert( arguments.length === 1 );
  return self._either( srcs,true );
}

eitherThen.having =
{
  consequizing : 1,
}

//

function eitherThenSplit( srcs )
{
  var self = this;
  _.assert( arguments.length === 1 );

  if( !_.arrayIs( srcs ) )
  srcs = [ srcs ];
  else
  srcs = srcs.slice();
  srcs.unshift( self );

  var con = new Self().give();
  con.eitherThen( srcs );
  return con;
}

eitherThenSplit.having =
{
  consequizing : 1,
}

//

function _either( srcs,thenning )
{
  var self = this;

  if( !_.arrayIs( srcs ) )
  srcs = [ srcs ];

  /* */

  var count = 0;
  function got( index,err,data )
  {

    count += 1;

    if( count === 1 )
    self.give( err,data );

    if( thenning )
    srcs[ index ].give( err,data );

  }

  /* */

  self.got( function( err,data )
  {

    for( var a = 0 ; a < srcs.length ; a++ )
    {
      var src = srcs[ a ];
      _.assert( _.consequenceIs( src ) || src === null );
      if( src === null )
      continue;
      src.got( _.routineJoin( undefined,got,[ a ] ) );
    }

  });

  return self;
}

//

/**
 * If type of `src` is function, the first method run it on begin, if the result of `src` invocation is instance of
   wConsequence, the current wConsequence will be wait for it resolving, else method added result to messages sequence
   of the current instance.
 * If `src` is instance of wConsequence, the current wConsequence delegates to it his first corespondent.
 * Returns current wConsequence instance.
 * @example
 * function handleGot1(err, val)
   {
     if( err )
     {
       console.log( 'handleGot1 error: ' + err );
     }
     else
     {
       console.log( 'handleGot1 value: ' + val );
     }
   };

   var con = new  _.Consequence();

   con.first( function()
   {
     return 'foo';
   });

 con.give( 100 );
 con.got( handleGot1 );
 // prints: handleGot1 value: foo
*
  function handleGot1(err, val)
  {
    if( err )
    {
      console.log( 'handleGot1 error: ' + err );
    }
    else
    {
      console.log( 'handleGot1 value: ' + val );
    }
  };

  var con = new  _.Consequence();

  con.first( function()
  {
    return _.Consequence().give(3);
  });

 con.give(100);
 con.got( handleGot1 );
 * @param {wConsequence|Function} src wConsequence or routine.
 * @returns {wConsequence}
 * @throws {Error} if `src` has unexpected type.
 * @method first
 * @memberof wConsequence#
 */

function first( src )
{
  var self = this;
  return self._first( src,null );
}

first.having =
{
  consequizing : 1,
}

//

function _first( src,stack )
{
  var self = this;

  _.assert( arguments.length === 2 );

  if( _.consequenceIs( src ) )
  {
    // throw _.err( 'not tested' );
    src.doThen( self );
    // src.give(); // xxx
  }
  else if( _.routineIs( src ) )
  {
    var result;

    try
    {
      result = src();
    }
    catch( err )
    {
      result = self.__handleError( err );
    }

    if( _.consequenceIs( result ) )
    result.doThen( self );
    else
    self.give( result );

  }
  else _.assert( 0,'first expects consequence of routine, but got',_.strTypeOf( src ) );

  return self;
}

//

function seal( context,method )
{
  var self = this;
  var result = Object.create( null );

  /**/

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.consequenceIs( this ) )

  result.consequence = self;

  result.ifNoErrorThen = function ifNoErrorThen( _method )
  {
    var args = method ? arguments : arguments[ 1 ];
    var c = _.routineSeal( context,method || _method,args );
    self.ifNoErrorThen( c );
    return this;
  }

  result.ifErrorThen = function ifErrorThen( _method )
  {
    var args = method ? arguments : arguments[ 1 ];
    var c = _.routineSeal( context,method || _method,args );
    self.ifErrorThen( c );
    return this;
  }

  result.doThen = function doThen( _method )
  {
    var args = method ? arguments : arguments[ 1 ];
    var c = _.routineSeal( context,method || _method,args );
    self.doThen( c );
    return this;
  }

  result.got = function got( _method )
  {
    var args = method ? arguments : arguments[ 2 ];
    var c = _.routineSeal( context,method || _method,args );
    self.got( c );
    return this;
  }

  return result;
}

// --
// messanger
// --

/**
 * Method pushes `message` into wConsequence messages queue.
 * Method also can accept two parameters: error, and
 * Returns current wConsequence instance.
 * @example
 * function gotHandler1( error, value )
   {
     console.log( 'handler 1: ' + value );
   };

   var con1 = new _.Consequence();

   con1.got( gotHandler1 );
   con1.give( 'hello' );

   // prints " handler 1: hello ",
 * @param {*} [message] Resolved value
 * @returns {wConsequence} consequence current wConsequence instance.
 * @throws {Error} if passed extra parameters.
 * @method give
 * @memberof wConsequence#
 */

function give( message )
{
  var self = this;
  _.assert( arguments.length === 2 || arguments.length === 1 || arguments.length === 0, 'expects 0, 1 or 2 arguments, got ' + arguments.length );
  if( arguments.length === 2 )
  return self.__giveAct( arguments[ 0 ],arguments[ 1 ] );
  else
  return self.__giveAct( null,message );
}

give.having =
{
  consequizing : 1,
}

//

/**
 * Using for adds to message queue error reason, that using for informing corespondent that will handle it, about
 * exception
 * @example
   function showResult(err, val)
   {
     if( err )
     {
       console.log( 'handleGot1 error: ' + err );
     }
     else
     {
       console.log( 'handleGot1 value: ' + val );
     }
   };

   var con = new  _.Consequence();

   function divade( x, y )
   {
     var result;
     if( y!== 0 )
     {
       result = x / y;
       con.give(result);
     }
     else
     {
       con.error( 'divide by zero' );
     }
   }

   con.got( showResult );
   divade( 3, 0 );

   // prints: handleGot1 error: divide by zero
 * @param {*|Error} error error, or value that represent error reason
 * @throws {Error} if passed extra parameters.
 * @method error
 * @memberof wConsequence#
 */

function error( error )
{
  var self = this;
  _.assert( arguments.length === 1 || arguments.length === 0 );
  if( arguments.length === 0  )
  error = _.err();
  return self.__giveAct( error,undefined );
}

error.having =
{
  consequizing : 1,
}

//

/**
 * Method creates and pushes message object into wConsequence messages sequence.
 * Returns current wConsequence instance.
 * @param {*} error Error value
 * @param {*} argument resolved value
 * @returns {_giveWithError}
 * @private
 * @throws {Error} if missed arguments or passed extra arguments
 * @method _giveWithError
 * @memberof wConsequence#
 */

function _giveWithError( error,argument )
{
  var self = this;

  _.assert( arguments.length === 2 );

  return self.__giveAct( error,argument );
}

//

function __giveAct( error,argument )
{
  var self = this;

  // if( error )
  // debugger;
  // if( error )
  // error = _.err( error );

  var message =
  {
    error : error,
    argument : argument,
  }

  if( _.consequenceIs( argument ) )
  _.assert( 0,'not tested' );

  if( self.diagnostics )
  if( Config.debug )
  if( self.debug )
  debugger;

  _.assert( !self.limitNumberOfMessages || self._message.length < self.limitNumberOfMessages );

  self.messageCounter += 1;
  self._message.push( message );
  self.__handleGot();

  return self;
}

//

/**
 * Creates and pushes message object into wConsequence messages sequence, and trying to get and return result of
    handling this message by appropriate correspondent.
 * @example
   var con = new  _.Consequence();

   function increment( err, value )
   {
     return ++value;
   };


   con.got( increment );
   var result = con.ping( undefined, 4 );
   console.log( result );
   // prints 5;
 * @param {*} error
 * @param {*} argument
 * @returns {*} result
 * @throws {Error} if missed arguments or passed extra arguments
 * @method ping
 * @memberof wConsequence#
 */

function _ping( error,argument )
{
  var self = this;

  throw _.err( 'deprecated' );

  _.assert( arguments.length === 2 );

  var message =
  {
    error : error,
    argument : argument,
  }

  self._message.push( message );
  var result = self.__handleGot();

  return result;
}

// --
// handling mechanism
// --

/**
 * Creates and handles error object based on `err` parameter.
 * Returns new wConsequence instance with error in messages queue.
 * @param {*} err error value.
 * @returns {wConsequence}
 * @private
 * @method __handleError
 * @memberof wConsequence#
 */

function __handleError( err,correspondent )
{
  var self = this;
  var err = _._err
  ({
    args : [ err ],
    level : 2,
  });

  if( Config.debug )
  if( correspondent && self.diagnostics && self.usingStack )
  err.stack = err.stack + '\n+\n' + correspondent.stack;

  if( !_.errIsAttended( err ) )
  _.errAttentionRequest( err );

  var result = new Self().error( err );

  if( err.attentionRequested )
  {
    debugger;

    if( Config.debug )
    logger.error( 'Consequence caught error, details come later' );

    _.timeOut( 100, function _unhandledError()
    {
      debugger;
      if( !_.errIsAttended( err ) )
      {
        logger.error( 'Unhandled error caught by Consequence :' );
        _.errLog( err );
      }
    });
  }

  return result;
}

//

/**
 * Method for processing corespondents and _message queue. Provides handling of resolved message values and errors by
    corespondents from correspondents value. Method takes first message from _message sequence and try to pass it to
    the first corespondent in corespondents sequence. Method returns the result of current corespondent execution.
    There are several cases of __handleGot behavior:
    - if corespondent is regular function:
      trying to pass messages error and argument values into corespondent and execute. If during execution exception
      occurred, it will be catch by __handleError method. If corespondent was not added by tap or persist method,
      __handleGot will remove message from head of queue.

      If corespondent was added by doThen, _onceThen, ifErrorThen, or by other "thenable" method of wConsequence, then:

      1) if result of corespondents is ordinary value, then __handleGot method appends result of corespondent to the
      head of messages queue, and therefore pass it to the next handler in corespondents queue.
      2) if result of corespondents is instance of wConsequence, __handleGot will append current wConsequence instance
      to result instance corespondents sequence.

      After method try to handle next message in queue if exists.

    - if corespondent is instance of wConsequence:
      in that case __handleGot pass message into corespondent`s messages queue.

      If corespondent was added by tap, or one of doThen, _onceThen, ifErrorThen, or by other "thenable" method of
      wConsequence then __handleGot try to pass current message to the next handler in corespondents sequence.

    - if in current wConsequence are present corespondents added by persist method, then __handleGot passes message to
      all of them, without removing them from sequence.

 * @returns {*}
 * @throws {Error} if on invocation moment the _message queue is empty.
 * @private
 * @method __handleGot
 * @memberof wConsequence#
 */

function __handleGot()
{
  var self = this;

  _.assert( self._message.length,'__handleGot : none message left' );

  if( self.asyncGiving )
  {
    if( !self._correspondentEarly.length && !self._correspondentLate.length )
    return;
    _.timeSoon( () => self.__handleGotAct() );
  }
  else
  {
    self.__handleGotAct();
  }

}

//

function __handleGotAct()
{
  var self = this;
  var result;
  var spliced = 0;

  if( !self._correspondentEarly.length && !self._correspondentLate.length )
  return;

  if( !self._message.length )
  return;

  var message = self._message[ 0 ];

  /* give message to correspondent consequence */

  function __giveToConsequence( correspondent,ordinary )
  {

    if( Config.debug )
    if( self.diagnostics )
    {
      _.arrayRemoveOnceStrictly( correspondent.onGot.dependsOf , self );
      if( self.debug || correspondent.onGot.debug )
      debugger;
    }

    result = correspondent.onGot.__giveAct( message.error,message.argument );

    if( ordinary )
    if( correspondent.thenning )
    if( self._message.length )
    {
      self.__handleGot();
    }

  }

  /* give message to correspondent routine */

  function __giveToRoutine( correspondent,ordinary )
  {

    var errThrowen = 0;
    var early = correspondent.early;
    var ifError = correspondent.kindOfArguments === Self.KindOfArguments.IfError;
    var ifNoError = correspondent.kindOfArguments === Self.KindOfArguments.IfNoError;

    var execute = true;
    var execute = execute && ( !ifError || ( ifError && !!message.error ) );
    var execute = execute && ( !ifNoError || ( ifNoError && !message.error ) );

    if( !execute )
    return;

    /* reuse */

    var resue = false;
    resue = resue || correspondent.tapping || !ordinary;
    resue = resue || !execute;

    if( !resue )
    {
      spliced = 1;
      self._message.shift();
    }

    /* debug */

    if( Config.debug )
    if( self.diagnostics )
    if( self.debug )
    debugger;

    /* call routine */

    try
    {
      if( ifError )
      result = correspondent.onGot.call( self,message.error );
      else if( ifNoError )
      result = correspondent.onGot.call( self,message.argument );
      else
      result = correspondent.onGot.call( self,message.error,message.argument );
    }
    catch( err )
    {
      errThrowen = 1;
      result = self.__handleError( err,correspondent );
    }

    /* thenning */

    if( correspondent.thenning || errThrowen )
    {

      if( _.consequenceIs( result ) )
      result.doThen( self );
      else
      self.give( result );

    }

  }

  /* give to */

  function __giveTo( correspondent,ordinary )
  {

    if( _.consequenceIs( correspondent.onGot ) )
    {
      __giveToConsequence( correspondent,ordinary );
    }
    else
    {
      __giveToRoutine( correspondent,ordinary );
    }

  }

  /* ordinary */

  if( self._correspondentEarly.length > 0 )
  {
    var correspondent = self._correspondentEarly.shift();
    __giveTo( correspondent,1 );
  }
  else if( self._correspondentLate.length > 0 )
  {
    var correspondent = self._correspondentLate.shift();
    __giveTo( correspondent,1 );
  }

  /* persistent */

  // if( 0 )
  // if( !correspondent || ( correspondent && !correspondent.tapping ) )
  // {
  //
  //   for( var i = 0 ; i < self._correspondentPersistent.length ; i++ )
  //   {
  //     var pTaker = self._correspondentPersistent[ i ];
  //     __giveTo( pTaker,0 );
  //   }
  //
  //   if( !spliced && self._correspondentPersistent.length )
  //   self._message.shift();
  //
  // }

  /* next message */

  if( self._message.length )
  self.__handleGot();

  return result;
}

//

/**
 * Method created and appends correspondent object, based on passed options into wConsequence correspondents queue.
 *
 * @param {Object} o options object
 * @param {wConsequence~Correspondent|wConsequence} o.onGot correspondent callback
 * @param {Object} [o.context] if defined, it uses as 'this' context in correspondent function.
 * @param {Array<*>|ArrayLike} [o.argument] values, that will be used as binding arguments in correspondent.
 * @param {boolean} [o.thenning=false] If sets to true, then result of current correspondent will be passed to the next correspondent
    in correspondents queue.
 * @param {boolean} [o.persistent=false] If sets to true, then correspondent will be work as queue listener ( it will be
 * processed every value resolved by wConsequence).
 * @param {boolean} [o.tapping=false] enabled some breakpoints in debug mode;
 * @returns {wConsequence}
 * @private
 * @method __correspondentAppend
 * @memberof wConsequence#
 */

function __correspondentAppend( o )
{
  var self = this;
  var correspondent = o.correspondent;

  _.assert( arguments.length === 1 );
  _.assert( _.consequenceIs( self ) );
  _.assert( _.routineIs( correspondent ) || _.consequenceIs( correspondent ) );
  _.assert( o.kindOfArguments >= 1 );
  _.assert( correspondent !== self,'consquence cant depend of itself' );
  _.assert( o.early !== undefined,'expects { o.early }' );
  _.routineOptions( __correspondentAppend,o );

  if( Config.debug )
  if( self.diagnostics )
  if( self.debug )
  debugger;

  /* */

  if( o.times !== 1 )
  {
    var optionsForAppend = _.mapExtend( null,o );
    optionsForAppend.times = 1;
    for( var t = 0 ; t < o.times ; t++ )
    self.__correspondentAppend( optionsForAppend );
    return self;
  }

  /* */

  if( !_.consequenceIs( correspondent ) )
  {

    if( Config.debug )
    if( o.kindOfArguments === Self.KindOfArguments.IfError || o.kindOfArguments === Self.KindOfArguments.IfNoError )
    if( o.kindOfArguments === Self.KindOfArguments.IfError )
    _.assert( correspondent.length <= 1, 'IfError correspondent expects single argument' );
    else
    _.assert( correspondent.length <= 1, 'IfNoError correspondent expects single argument' );

  }

  /* store */

  // if( o.persistent )
  // self._correspondentPersistent.push
  // ({
  //   onGot : correspondent,
  // });
  // else
  {

    if( Config.debug )
    if( self.diagnostics )
    if( _.consequenceIs( correspondent ) )
    {

      self.assertNoDeadLockWith( correspondent );
      correspondent.dependsOf.push( self );

      if( Config.debug )
      if( self.diagnostics )
      if( correspondent.debug )
      debugger;
    }

    var correspondentDescriptor =
    {
      consequence : self,
      onGot : correspondent,
      thenning : !!o.thenning,
      tapping : !!o.tapping,
      kindOfArguments : o.kindOfArguments,
      early : o.early,
    }

    if( !o.tenning )
    self.messageCounter -= 1;

    if( Config.debug )
    if( self.diagnostics )
    correspondentDescriptor.stack = _.diagnosticStack( 2 );

    if( o.early )
    self._correspondentEarly.push( correspondentDescriptor );
    else
    self._correspondentLate.unshift( correspondentDescriptor );
  }

  /* got */

  if( self.asyncTaking )
  _.timeSoon( function()
  {

    if( self._message.length )
    self.__handleGot();

  });
  else
  {

    if( self._message.length )
    self.__handleGot();

  }

  /* */

  return self;
}

__correspondentAppend.defaults =
{
  correspondent : null,
  thenning : null,
  tapping : null,
  kindOfArguments : null,
  // persistent : 0,
  times : 1,
  early : 1,
}

// --
// accounting
// --

function correspondentHas( correspondent )
{
  var self = this;

  _.assert( _.consequenceIs( correspondent ) );

  for( var c = 0 ; c < self._correspondentEarly.length ; c++ )
  {
    var cor = self._correspondentEarly[ c ].onGot;
    if( cor === correspondent )
    return true;
    if( _.consequenceIs( cor ) )
    if( cor.correspondentHas( correspondent ) )
    return true;
  }

  for( var c = 0 ; c < self._correspondentLate.length ; c++ )
  {
    var cor = self._correspondentLate[ c ].onGot;
    if( cor === correspondent )
    return true;
    if( _.consequenceIs( cor ) )
    if( cor.correspondentHas( correspondent ) )
    return true;
  }

  return false;
}

//

function doesDependOf( correspondent )
{
  var self = this;

  _.assert( _.consequenceIs( correspondent ) );

  if( !self.dependsOf )
  return false;

  for( var c = 0 ; c < self.dependsOf.length ; c++ )
  {
    var cor = self.dependsOf[ c ];
    if( cor === correspondent )
    return true;
    if( _.consequenceIs( cor ) )
    if( cor.doesDependOf( correspondent ) )
    return true;
  }

  return false;
}

//

function assertNoDeadLockWith( correspondent )
{
  var self = this;

  _.assert( _.consequenceIs( correspondent ) );
  // _.assert( !correspondent.correspondentHas( self ),'dead lock!' );

  var result = self.doesDependOf( correspondent );
  var msg = '';

  if( result )
  {
    msg += 'Dead lock!\n';
    // msg += 'with consequence :\n' + correspondent.stack;
  }

  _.assert( !result,msg );

  return result;
}

//

/**
 * The _corespondentMap object
 * @typedef {Object} _corespondentMap
 * @property {Function|wConsequence} onGot function or wConsequence instance, that accepts resolved messages from
 * messages queue.
 * @property {boolean} thenning determines if corespondent pass his result back into messages queue.
 * @property {boolean} tapping determines if corespondent return accepted message back into  messages queue.
 * @property {boolean} ifError turn on corespondent only if message represent error;
 * @property {boolean} ifNoError turn on corespondent only if message represent no error;
 * @property {boolean} debug enables debugging.
 * @property {string} id corespondent id.
 */

/**
 * Returns array of corespondents
 * @example
 * function corespondent1(err, val)
   {
     console.log( 'corespondent1 value: ' + val );
   };

   function corespondent2(err, val)
   {
     console.log( 'corespondent2 value: ' + val );
   };

   function corespondent3(err, val)
   {
     console.log( 'corespondent1 value: ' + val );
   };

   var con = _.Consequence();

   con.tap( corespondent1 ).doThen( corespondent2 ).got( corespondent3 );

   var corespondents = con.correspondentsEarlyGet();

   console.log( corespondents );

   // prints
   // [ {
   //  onGot: [Function: corespondent1],
   //  thenning: true,
   //  tapping: true,
   //  ifError: false,
   //  ifNoError: false,
   //  debug: false,
   //  id: 'corespondent1' },
   // { onGot: [Function: corespondent2],
   //   thenning: true,
   //   tapping: false,
   //   ifError: false,
   //   ifNoError: false,
   //   debug: false,
   //   id: 'corespondent2' },
   // { onGot: [Function: corespondent3],
   //   thenning: false,
   //   tapping: false,
   //   ifError: false,
   //   ifNoError: false,
   //   debug: false,
   //   id: 'corespondent3'
   // } ]
 * @returns {_corespondentMap[]}
 * @method correspondentsEarlyGet
 * @memberof wConsequence
 */

function correspondentsEarlyGet()
{
  var self = this;
  return self._correspondentEarly;
}

//

function correspondentsLateGet()
{
  var self = this;
  return self._correspondentLate;
}

//

/**
 * If called without arguments, method correspondentsCancel() removes all corespondents from wConsequence
 * correspondents queue.
 * If as argument passed routine, method correspondentsCancel() removes it from corespondents queue if exists.
 * @example
 function corespondent1(err, val)
 {
   console.log( 'corespondent1 value: ' + val );
 };

 function corespondent2(err, val)
 {
   console.log( 'corespondent2 value: ' + val );
 };

 function corespondent3(err, val)
 {
   console.log( 'corespondent1 value: ' + val );
 };

 var con = _.Consequence();

 con.got( corespondent1 ).got( corespondent2 );
 con.correspondentsCancel();

 con.got( corespondent3 );
 con.give( 'bar' );

 // prints
 // corespondent1 value: bar
 * @param [correspondent]
 * @method correspondentsCancel
 * @memberof wConsequence
 */

function correspondentsCancel( correspondent )
{
  var self = this;

  _.assert( arguments.length === 0 || _.routineIs( correspondent ) );

  if( arguments.length === 0 )
  {
    self._correspondentEarly.splice( 0,self._correspondentEarly.length );
    self._correspondentLate.splice( 0,self._correspondentLate.length );
  }
  else
  {
    throw _.err( 'not tested' );
    _.arrayRemoveOnce( self._correspondentEarly,correspondent );
    _.arrayRemoveOnce( self._correspondentLate,correspondent );
  }

}

//

function _correspondentNextGet()
{
  var self = this;

  if( !self._correspondentEarly[ 0 ] )
  {
    if( !self._correspondentLate[ 0 ] )
    return;
    else
    return self._correspondentLate[ 0 ].onGot;
  }
  else
  {
    return self._correspondentEarly[ 0 ].onGot;
  }

}

//

/**
 * The internal wConsequence view of message.
 * @typedef {Object} _messageObject
 * @property {*} error error value
 * @property {*} argument resolved value
 */

/**
 * Returns messages queue.
 * @example
 * var con = _.Consequence();

   con.give( 'foo' );
   con.give( 'bar ');
   con.error( 'baz' );


   var messages = con.messagesGet();

   console.log( messages );

   // prints
   // [ { error: null, argument: 'foo' },
   // { error: null, argument: 'bar ' },
   // { error: 'baz', argument: undefined } ]

 * @returns {_messageObject[]}
 * @method messagesGet
 * @memberof wConsequence
 */

function messagesGet( index )
{
  var self = this;
  _.assert( arguments.length === 0 || arguments.length === 1 )
  _.assert( index === undefined || _.numberIs( index ) );
  if( index !== undefined )
  return self._message[ index ];
  else
  return self._message;
}

//

/**
 * If called without arguments, method removes all messages from wConsequence
 * correspondents queue.
 * If as argument passed value, method messagesCancel() removes it from messages queue if messages queue contains it.
 * @example
 * var con = _.Consequence();

   con.give( 'foo' );
   con.give( 'bar ');
   con.error( 'baz' );

   con.messagesCancel();
   var messages = con.messagesGet();

   console.log( messages );
   // prints: []
 * @param {_messageObject} data message object for removing.
 * @throws {Error} If passed extra arguments.
 * @method correspondentsCancel
 * @memberof wConsequence
 */

function messagesCancel( data )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( arguments.length === 0 )
  self._message.splice( 0,self._message.length );
  else
  {
    throw _.err( 'not tested' );
    _.arrayRemoveOnce( self._message,data );
  }

}

//

/**
 * Returns number of messages in current messages queue.
 * @example
 * var con = _.Consequence();

   var conLen = con.messageHas();
   console.log( conLen );

   con.give( 'foo' );
   con.give( 'bar' );
   con.error( 'baz' );
   conLen = con.messageHas();
   console.log( conLen );

   con.messagesCancel();

   conLen = con.messageHas();
   console.log( conLen );
   // prints: 0, 3, 0;

 * @returns {number}
 * @method messageHas
 * @memberof wConsequence
 */

function messageHas()
{
  var self = this;
  // debugger;
  return self.messageCounter > 0;
  // if( self._message.length <= self._correspondentEarly.length )
  // return 0;
  // return self._message.length - self._correspondentEarly.length;
}

//

/**
 * Clears all messages and corespondents of wConsequence.
 * @method clear
 * @memberof wConsequence
 */

function clear( data )
{
  var self = this;
  _.assert( arguments.length === 0 );

  self.correspondentsCancel();
  self.messagesCancel();

}

//

function cancel()
{
  var self = this;
  _.assert( arguments.length === 0 );

  self.clear();

  return self;
}

// --
// etc
// --

/**
 * Serializes current wConsequence instance.
 * @example
 * function corespondent1(err, val)
   {
     console.log( 'corespondent1 value: ' + val );
   };

   var con = _.Consequence();
   con.got( corespondent1 );

   var conStr = con.toStr();

   console.log( conStr );

   con.give( 'foo' );
   con.give( 'bar' );
   con.error( 'baz' );

   conStr = con.toStr();

   console.log( conStr );
   // prints:

   // wConsequence( 0 )
   // message : 0
   // correspondents : 1
   // correspondent names : corespondent1

   // corespondent1 value: foo

   // wConsequence( 0 )
   // message : 2
   // correspondents : 0
   // correspondent names :

 * @returns {string}
 * @method toStr
 * @memberof wConsequence
 */

function toStr()
{
  var self = this;
  var result = self.nickName;

  var names = _.entitySelect( self.correspondentsEarlyGet(),'*.tag' );

  result += '\n  messages : ' + self.messagesGet().length;
  result += '\n  correspondents : ' + self.correspondentsEarlyGet().length;
  result += '\n  tag : ' + self.tag;
  // result += '\n  correspondent names : ' + names.join( ' ' );

  return result;
}

//

function toString()
{
  var self = this;
  return self.toStr();
}

//

// /**
//  * Can use as correspondent. If `err` is not null, throws exception based on `err`. Returns `data`.
//  * @callback wConsequence._onDebug
//  * @param {*} err Error object, or any other type, that represent or describe an error reason. If during resolving
//  value no exception occurred, it will be set to null;
//  * @param {*} data resolved by wConsequence value;
//  * @returns {*}
//  * @memberof wConsequence
//  */
//
// function _onDebug( err,data )
// {
//   debugger;
//   if( err )
//   throw _.err( err );
//   return data;
// }

//

function __call__()
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );
  if( arguments.length === 2 )
  self.give( arguments[ 0 ],arguments[ 1 ] );
  else
  self.give( arguments[ 0 ] );

}

// --
// static
// --

/*

var onReady = caching.fileWatcher.onReady.eitherThenSplit( _.timeOutError( timeOut ) );

*/

function from_static( src,timeOut )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( timeOut === undefined || _.numberIs( timeOut ) );

  var con = src;

  if( _.promiseIs( src ) )
  {
    con = new Self();
    var onFulfilled = ( got ) => { con.give( got ); }
    var onRejected = ( err ) => { con.error( err ); }
    src.then( onFulfilled, onRejected );
  }

  if( _.consequenceIs( con ) )
  {
    if( timeOut !== undefined )
    return con.eitherThenSplit( _.timeOutError( timeOut ) );

    return con;
  }

  if( _.errIs( src ) )
  return new Self().error( src );

  return new Self().give( src );
}

//

/**
 * If `consequence` if instance of wConsequence, method pass arg and error if defined to it's message sequence.
 * If `consequence` is routine, method pass arg as arguments to it and return result.
 * @example
 * function showResult(err, val)
   {
     if( err )
     {
       console.log( 'handleGot1 error: ' + err );
     }
     else
     {
       console.log( 'handleGot1 value: ' + val );
     }
   };

   var con = new  _.Consequence();

   con.got( showResult );

   _.Consequence.give( con, 'hello world' );
   // prints: handleGot1 value: hello world
 * @param {Function|wConsequence} consequence
 * @param {*} arg argument value
 * @param {*} [error] error value
 * @returns {*}
 * @static
 * @method give
 * @memberof wConsequence
 */

function give_static( consequence )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );

  var err,got;
  if( arguments.length === 2 )
  {
    got = arguments[ 1 ];
  }
  else if( arguments.length === 3 )
  {
    err = arguments[ 1 ];
    got = arguments[ 2 ];
  }

  var args = [ got ];

  return _give_static
  ({
    consequence : consequence,
    context : undefined,
    error : err,
    args : args,
  });

}

//

  /**
   * If `o.consequence` is instance of wConsequence, method pass o.args and o.error if defined, to it's message sequence.
   * If `o.consequence` is routine, method pass o.args as arguments to it and return result.
   * @param {Object} o parameters object.
   * @param {Function|wConsequence} o.consequence wConsequence or routine.
   * @param {Array} o.args values for wConsequence messages queue or arguments for routine.
   * @param {*|Error} o.error error value.
   * @returns {*}
   * @private
   * @throws {Error} if missed arguments.
   * @throws {Error} if passed argument is not object.
   * @throws {Error} if o.consequence has unexpected type.
   * @method _give_static
   * @memberof wConsequence
   */

function _give_static( o )
{
  var context;

  if( !( _.arrayIs( o.args ) && o.args.length <= 1 ) )
  debugger;

  _.assert( arguments.length === 1 );
  _.assert( _.objectIs( o ) );
  _.assert( _.arrayIs( o.args ) && o.args.length <= 1, 'not tested' );

  /**/

  if( _.arrayIs( o.consequence ) )
  {

    for( var i = 0 ; i < o.consequence.length ; i++ )
    {
      var optionsGive = _.mapExtend( Object.create( null ),o );
      optionsGive.consequence = o.consequence[ i ];
      _give_static( optionsGive );
    }

  }
  else if( _.consequenceIs( o.consequence ) )
  {

    _.assert( _.arrayIs( o.args ) && o.args.length <= 1 );

    context = o.consequence;

    if( o.error !== undefined )
    {
      o.consequence.__giveAct( o.error,o.args[ 0 ] );
    }
    else
    {
      o.consequence.give( o.args[ 0 ] );
    }

  }
  else if( _.routineIs( o.consequence ) )
  {

    _.assert( _.arrayIs( o.args ) && o.args.length <= 1 );

    if( o.error !== undefined )
    {
      return o.consequence.call( context,o.error,o.args[ 0 ] );
    }
    else
    {
      return o.consequence.call( context,null,o.args[ 0 ] );
    }

  }
  else throw _.err( 'Unknown type of consequence : ' + _.strTypeOf( o.consequence ) );

}

//

  /**
   * If `consequence` if instance of wConsequence, method error to it's message sequence.
   * If `consequence` is routine, method pass error as arguments to it and return result.
   * @example
   * function showResult(err, val)
     {
       if( err )
       {
         console.log( 'handleGot1 error: ' + err );
       }
       else
       {
         console.log( 'handleGot1 value: ' + val );
       }
     };

     var con = new  _.Consequence();

     con.got( showResult );

     wConsequence.error( con, 'something wrong' );
   // prints: handleGot1 error: something wrong
   * @param {Function|wConsequence} consequence
   * @param {*} error error value
   * @returns {*}
   * @static
   * @method error
   * @memberof wConsequence
   */

function error_static( consequence,error )
{

  _.assert( arguments.length === 2 );

  return _give_static
  ({
    consequence : consequence,
    context : undefined,
    error : error,
    args : [],
  });

}

//

  /**
   * Works like [give]{@link _.Consequence.give} but accepts also context, that will be sealed to correspondent.
   * @see _.Consequence.give
   * @param {Function|wConsequence} consequence wConsequence or routine.
   * @param {Object} context sealed context
   * @param {*} err error reason
   * @param {*} got arguments
   * @returns {*}
   * @method giveWithContextAndError
   * @memberof wConsequence
   */

function giveWithContextAndError_static( consequence,context,err,got )
{

  if( err === undefined )
  err = null;

  console.warn( 'deprecated' );
  //debugger;

  var args = [ got ];
  if( arguments.length > 4 )
  args = _.arraySlice( arguments,3 );

  return _give_static
  ({
    consequence : consequence,
    context : context,
    error : err,
    args : args,
  });

}

//

/**
 * Method accepts correspondent callback. Returns special correspondent that wrap passed one. Passed corespondent will
 * be invoked only if handling message contains error value. Else given message will be delegate to the next handler
 * in wConsequence, to the which result correspondent was added.
 * @param {correspondent} errHandler handler for error
 * @returns {correspondent}
 * @static
 * @thorws If missed arguments or passed extra ones.
 * @method ifErrorThen
 * @memberof wConsequence
 * @see {@link wConsequence#ifErrorThen}
 */

function ifErrorThen_static()
{

  _.assert( arguments.length === 1 );
  _.assert( this === Self );

  var onEnd = arguments[ 0 ];
  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( onEnd ) );

  return function ifErrorThen( err,data )
  {

    _.assert( arguments.length === 2 );

    if( err )
    {
      return onEnd( err,data );
    }
    else
    {
      return new Self().give( data );
    }

  }

}

//

  /**
   * Method accepts correspondent callback. Returns special correspondent that wrap passed one. Passed corespondent will
   * be invoked only if handling message does not contain error value. Else given message with error will be delegate to
   * the next handler in wConsequence, to the which result correspondent was added.
   * @param {correspondent} vallueHandler resolved message handler
   * @returns {corespondent}
   * @static
   * @throws {Error} If missed arguments or passed extra one;
   * @method ifNoErrorThen
   * @memberof wConsequence
   */

function ifNoErrorThen_static()
{

  _.assert( arguments.length === 1 );
  _.assert( this === Self );

  var onEnd = arguments[ 0 ];
  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( onEnd ) );

  return function ifNoErrorThen( err,data )
  {

    _.assert( arguments.length === 2 );

    if( !err )
    {
      return onEnd( err,data );
    }
    else
    {
      return new Self().error( err );
    }

  }

}

//

/**
 * Can use as correspondent. If `err` is not null, throws exception based on `err`. Returns `data`.
 * @callback wConsequence.passThru
 * @param {*} err Error object, or any other type, that represent or describe an error reason. If during resolving
 value no exception occurred, it will be set to null;
 * @param {*} data resolved by wConsequence value;
 * @returns {*}
 * @memberof wConsequence
 */

var passThru_static = function passThru( err,data )
{
  if( err )
  throw _.err( err );
  return data;
}

// --
// experimental
// --

function FunctionWithin( consequence )
{
  var routine = this;
  var args;
  var context;

  _.assert( arguments.length === 1 );
  _.assert( _.consequenceIs( consequence ) );

  consequence.doThen( function( err,data )
  {

    return routine.apply( context,args );

  });

  return function()
  {
    context = this;
    args = arguments;
    return consequence;
  }

}

//

function FunctionThereafter()
{
  var con = new Self();
  var routine = this;
  var args = arguments

  con.doThen( function( err,data )
  {

    return routine.apply( null,args );

  });

  return con;
}

//

if( 0 )
{
  Function.prototype.within = FunctionWithin;
  Function.prototype.thereafter = FunctionThereafter;
}

//

function experimentThereafter()
{
  debugger;

  function f()
  {
    debugger;
    console.log( 'done2' );
  }

  _.timeOut( 5000,console.log.thereafter( 'done' ) );
  _.timeOut( 5000,f.thereafter() );

  debugger;

}

//

function experimentWithin()
{

  debugger;
  var con = _.timeOut( 30000 );
  console.log.within( con ).call( console,'done' );
  con.doThen( function()
  {

    debugger;
    console.log( 'done2' );

  });

}

//

function experimentCall()
{

  var con = new Self();
  con( 123 );
  con.doThen( function( err,data )
  {

    console.log( 'got :',data );

  });

  debugger;

}

// --
// type
// --

var KindOfArguments =
{
  IfError : 1,
  IfNoError : 2,
  Both : 3,
  BothWithCorrespondent : 4,
}

// --
// relationships
// --

var Composes =
{
  _correspondentEarly : [],
  _correspondentLate : [],
  _message : [],
  messageCounter : 0,
}

var ComposesDebug =
{
  tag : '',
  dependsOf : [],
  debug : 0,
  limitNumberOfMessages : 0,
}

if( Config.debug )
_.mapExtend( Composes,ComposesDebug );

var Restricts =
{
}

var Statics =
{

  from : from_static,

  _give : _give_static,
  give : give_static,

  error : error_static,

  giveWithContextAndError : giveWithContextAndError_static,

  ifErrorThen : ifErrorThen_static,
  ifNoErrorThen : ifNoErrorThen_static,

  passThru : passThru_static,

  KindOfArguments : KindOfArguments,
  diagnostics : 1,
  usingStack : 0,
  asyncTaking : 0,
  asyncGiving : 0,

  nameShort : 'Consequence',

}

var Forbids =
{
  every : 'every',
  mutex : 'mutex',
  mode : 'mode',
  _correspondent : '_correspondent',
  _correspondentPersistent : '_correspondentPersistent',
}

// --
// proto
// --

var Extend =
{

  init : init,


  // chainer

  got : got,
  lateGot : lateGot,
  promiseGot : promiseGot,
  done : got,

  doThen : doThen,
  _doThen : _doThen,
  lateThen : lateThen,
  promiseThen : promiseThen,

  choke : choke,
  chokeThen : chokeThen,

  _onceGot : _onceGot, /* experimental */
  _onceThen : _onceThen, /* experimental */

  split : split,
  tap : tap,

  ifNoErrorGot : ifNoErrorGot,
  ifNoErrorThen : ifNoErrorThen,

  ifErrorGot : ifErrorGot,
  ifErrorThen : ifErrorThen,
  ifErrorThenLogThen : ifErrorThenLogThen, /* experimental */

  /* debugThen : debugThen, experimental */
  timeOutThen : timeOutThen,

  /* persist : persist, */ /* deprecated */


  // advanced

  andGot : andGot,
  andThen : andThen,
  _and : _and,

  eitherGot : eitherGot,
  eitherThen : eitherThen,
  eitherThenSplit : eitherThenSplit,
  _either : _either,

  first : first,
  _first : _first,

  seal : seal, /* experimental */


  // messanger

  give : give,
  error : error,
  _giveWithError : _giveWithError,
  __giveAct : __giveAct,
  _ping : _ping, /* experimental */


  // handling mechanism

  __handleError : __handleError,
  __handleGot : __handleGot,
  __handleGotAct : __handleGotAct,
  __correspondentAppend : __correspondentAppend,


  // accounting

  correspondentHas : correspondentHas,
  doesDependOf : doesDependOf,
  assertNoDeadLockWith : assertNoDeadLockWith,

  correspondentsEarlyGet : correspondentsEarlyGet,
  correspondentsLateGet : correspondentsLateGet,
  correspondentsCancel : correspondentsCancel,
  _correspondentNextGet : _correspondentNextGet,

  messagesGet : messagesGet,
  messagesCancel : messagesCancel,
  messageHas : messageHas,

  clear : clear, /* experimental */
  cancel : cancel, /* experimental */


  // etc

  toStr : toStr,
  toString : toString,
  __call__ : __call__,


  // relationships

  constructor : wConsequence,
  Composes : Composes,
  Restricts : Restricts,

}

//

/* statics should be supplemental not extending */

var Supplement =
{
  Statics : Statics,
}

//

_.classMake
({
  cls : wConsequence,
  parent : null,
  extend : Extend,
  supplement : Supplement,
  usingOriginalPrototype : 1,
});

_.Copyable.mixin( wConsequence );

//

_.assert( _.routineIs( wConsequence.prototype.passThru ) );
_.assert( _.routineIs( wConsequence.passThru ) );
_.assert( _.objectIs( wConsequence.prototype.KindOfArguments ) );
_.assert( _.objectIs( wConsequence.KindOfArguments ) );
_.assert( _.strIsNotEmpty( wConsequence.name ) );
_.assert( _.strIsNotEmpty( wConsequence.nameShort ) );
_.assert( _.routineIs( wConsequence.prototype.give ) );

_.assert( _.routineIs( wConsequenceProxy.prototype.passThru ) );
_.assert( _.routineIs( wConsequenceProxy.passThru ) );
_.assert( _.objectIs( wConsequenceProxy.prototype.KindOfArguments ) );
_.assert( _.objectIs( wConsequenceProxy.KindOfArguments ) );
_.assert( _.strIsNotEmpty( wConsequenceProxy.name ) );
_.assert( _.strIsNotEmpty( wConsequenceProxy.nameShort ) );
_.assert( _.routineIs( wConsequenceProxy.prototype.give ) );

_.assert( wConsequenceProxy.nameShort === 'Consequence' );

//

_.accessor
({
  object : Self.prototype,
  names :
  {
    correspondentNext : 'correspondentNext',
  }
});

_.accessorForbid( Self.prototype,Forbids );

_globalReal_[ Self.name ] = _global_[ Self.name ] = _[ Self.nameShort ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_._UsingWtoolsPrivately_ )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();