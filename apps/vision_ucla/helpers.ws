
include "stdlib.ws"

//====================================================================================================
/// General helpers:

/// Nested arrays
// Note, these functions should be replaced with a proper multi-dimensional matrix library.

//====================================================================================================
// 3D arrays, nested implementation:

fun Array3D:fill(arr, val) {
  for i = 0 to Array:length(arr)-1 {
   for j = 0 to Array:length(arr[i])-1 {
       Array:fill(arr[i][j], val);
     }};
}

// Assumes they're of the same dimension.  If not, you'll get an
// unhelpful out of bounds error.
fun Array3D:foreach2(arr1, arr2, fn) {
  using Array;
   if DEBUG then assert_eq("foreach2_3D: length mismatch", arr1.length, arr2.length);
  for i = 0 to length(arr1)-1 {
    if DEBUG then assert_eq("foreach2_3D: inner length mismatch", arr1[i].length, arr2[i].length);
   for j = 0 to length(arr1[i])-1 { 
     if DEBUG then assert_eq("foreach2_3D: inner inner length mismatch", arr1[i][j].length, arr2[i][j].length);
    for k = 0 to length(arr1[i][j])-1 {
      fn(arr1[i][j][k], arr2[i][j][k])
  }}};
}

// A fold over two 3D arrays:
fun Array3D:fold2(arr1, arr2, zer, fn) {
  acc = ref$ zer;
  Array3D:foreach2(arr1, arr2, fun(a,b) acc := fn(acc, a, b));	 
  acc
}

fun Array3D:map_inplace(arr, fn) {
  for i = 0 to Array:length(arr)       - 1 {
  for j = 0 to Array:length(arr[i])    - 1 {
  for k = 0 to Array:length(arr[i][j]) - 1 {
     arr[i][j][k] := fn(arr[i][j][k]);
  }}}
}

fun Array3D:iter(arr, fn) {
  for i = 0 to Array:length(arr)       - 1 {
  for j = 0 to Array:length(arr[i])    - 1 {
  for k = 0 to Array:length(arr[i][j]) - 1 {
    fn(i,j,k)
  }}}  
}

fun Array3D:make(i,j,k, val) {
  using Array;
  build(i, fun(_)
  build(j, fun(_)
   make(k, val)));
}

fun Array3D:map_inplace2(arr, arr2, fn) {
  for i = 0 to Array:length(arr)       - 1 {
  for j = 0 to Array:length(arr[i])    - 1 {
  for k = 0 to Array:length(arr[i][j]) - 1 {
    arr[i][j][k] := fn(arr[i][j][k], arr2[i][j][k]);
  }}}
}

//====================================================================================================
// 3D arrays, flat implementation




//====================================================================================================

fun Array:make4D(i,j,k,l, val) {
  using Array;
  build(i, fun(_) 
  build(j, fun(_)
  build(k, fun(_)
   make(l, val))));
}


