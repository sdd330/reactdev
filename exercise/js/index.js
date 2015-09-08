/**
 *  index.js launch the application.
 *
 *  @author  Yang Leijun
 *  @date    Sep 6, 2015
 *
 */
'use strict';
import React from 'react';

var HelloMessage = React.createClass({
  render: function() {
    return <div>Hello Leijun</div>;
  }
});

React.render(<HelloMessage />, document.body);
