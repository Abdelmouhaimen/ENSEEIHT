import React from 'react';

function Preloader({ load }) {
  return (
    <div id={load ? "preloader" : "preloader-none"}></div>
  );
}

export default Preloader;
