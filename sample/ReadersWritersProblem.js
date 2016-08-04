/*
 Problem describes situation in which many threads try to access the same shared resource at one time. Some threads may
 read and some may write, with the constraint that no process may access the share for either reading or writing, while
 another process is in the act of writing to it. (In particular, it is allowed for two or more readers to access the share
 at the same time.)

 source: https://en.wikipedia.org/wiki/Readers%E2%80%93writers_problem
 */

if( typeof module !== 'undefined' )
{
  var _ = require( 'wTools' );
  /* require( 'wConsequence' ); */
  /* require( '../staging/abase/syn/Consequence.s' ); */
}

var resource = {
  sharedData : '',
  readers: [],
  writers: [],
};

function RWSubject( name )
{
  this.name = name;
  this.read = function() {
    console.log(resource.sharedData);
  };

  this.write = function() {
    resource.sharedData += this.name + 'was here);\n';
  };
}

function createRWsubjects( rwConstructor )
{
  var rwSubjects = [];
  for ( var i = 1; i < 5; i++)
    rwSubjects.push( new rwConstructor(i) );
  return rwSubjects
}


var rwEventList =
  {
    '1':
      [
        { operation: 'write', delay: 1000, duration: 1500 },
        { operation: 'read', delay: 3000, duration: 2000 },
        { operation: 'read', delay: 5000, duration: 1000 },
        { operation: 'write', delay: 7000, duration: 500 },
        { operation: 'read', delay: 9000, duration: 1700 },
        { operation: 'write', delay: 11000, duration: 4000 }
      ],
    '2':
      [
        { operation: 'write', delay: 2000, duration: 1000 },
        { operation: 'read', delay: 6000, duration: 500 },
        { operation: 'read', delay: 7000, duration: 600 },
        { operation: 'read', delay: 9000, duration: 600 },
        { operation: 'write', delay: 11000, duration: 1000 }
      ],
    '3':
      [
        { operation: 'write', delay: 0, duration: 200 },
        { operation: 'read', delay: 2000, duration: 200 },
        { operation: 'write', delay: 4000, duration: 1400 },
        { operation: 'read', delay: 6000, duration: 1300 },
        { operation: 'read', delay: 8000, duration: 200 }
      ],
    '4':
      [
        { operation: 'read', delay: 1000, duration: 200 },
        { operation: 'read', delay: 2000, duration: 300 },
        { operation: 'write', delay: 3000, duration: 200 },
        { operation: 'write', delay: 4000, duration: 200 },
        { operation: 'read', delay: 5000, duration: 400 },
        { operation: 'read', delay: 6000, duration: 200 }
      ]
  };

function simulateReadWriteEvent()
{
  var subject;
  for( subject in rwEventList )
  {
    if( !rwEventList.hasOwnProperty( subject ) )
      continue;

    var i = 0,
      list = rwEventList[ subject ],
      len = list.length,
      time = _.timeNow(),
      rWSubject = this.rwSubjects[ subject - 1 ];
    for( ; i < len; i++ )
    {
      var event = list[ i ];
      setTimeout( ( function( rWSubject, event )
      {
        var context = {};
        context.time = time;
        context.rwSubject = rWSubject;
        context.event = event;
        this.precessEvent( context );
      }).bind( this, rWSubject, event ), event.delay );
    }
  }
}

function  precessEvent( opt )
{
  console.log( 'try to perform ' + opt.event.operation + ' by ' + opt.rwSubject.name + ' at '
    + _.timeSpent( ' ',opt.time ) );

  var resource = this.resource;

  if( opt.event.operation == 'read' )
  {
    if ( resource.writers.length > 0 )
    {
      console.log('PROBLEM: ' + opt.rwSubject.name + 'can`t read resource, because it busy by ' +
      resource.writers.join( ', ' ) + 'subjects' );
    }
    else {
      resource.readers.push( opt.rwSubject.name );
      console.log( 'start read by ' + opt.rwSubject.name );
      setTimeout( ( function(opt) {
        console.log( 'end read by ' + opt.rwSubject.name );
        opt.rwSubject.read();
        _.arrayRemovedOnce(resource.readers, opt.rwSubject.name);
      } ).bind( null, opt ), opt.event.duration );
    }
  }
  else if( opt.event.operation == 'write' )
  {
    if ( resource.writers.length + resource.readers.length > 0 )
    {
      console.log('PROBLEM: ' + opt.rwSubject.name + 'can`t wwrite resource, because it busy by ' +
        resource.readers.join( ', ' ) + ' read subjects and ' + resource.writers.join( ', ' ) + ' write subjects' );
    }
    else {
      resource.writers.push( opt.rwSubject.name );
      console.log( 'start write by ' + opt.rwSubject.name );
      setTimeout( ( function(opt) {
        console.log( 'end write by ' + opt.rwSubject.name );
        opt.rwSubject.write();
        _.arrayRemovedOnce(resource.readers, opt.rwSubject.name);
      } ).bind( null, opt ), opt.event.duration );
    }
  }

}

function init( rwConstructor )
{
  this.rwSubjects = this.createRWsubjects( rwConstructor );
  this.simulateReadWriteEvent();
}

var Self =
{
  resource: resource,
  precessEvent : precessEvent,
  simulateReadWriteEvent : simulateReadWriteEvent,
  createRWsubjects: createRWsubjects,
  init: init,
};

//

if( typeof module !== 'undefined' )
{
  module[ 'exports' ] = Self;
  module[ 'exports' ][ 'RWSubject' ] = RWSubject;
  if( !module.parent )
    Self.init( RWSubject );
}