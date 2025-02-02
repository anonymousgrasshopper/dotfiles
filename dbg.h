#include <iostream>
#include <string>
#include <type_traits>
#include <vector>
using namespace std;

#define line() cerr << "Line " << __LINE__ << " : ";
#define id(x) cerr << #x << " : \n=======\n";
#define n(x)                  \
  for (int i = 0; i < x; i++) \
    cerr << '\n';

inline string dbg_format(bool& x) {
  return (x ? "true" : "false");
}
inline string dbg_format(char& x) {
  return "\'" + to_string(x) + "\'";
}
inline string dbg_format(string& x) {
  return "\"" + x + "\"";
}
template <typename A, typename B>
inline string dbg_format(pair<A, B> x) {
  return "(" + dbg_format(x.first) + "," + dbg_format(x.second) + ")";
}
template <typename A, typename B, typename C>
inline string dbg_format(tuple<A, B, C> x) {
  return "(" + dbg_format(x.get(0)) + "," + dbg_format(x.get(1)) + "," + dbg_format(x.get(2)) + ")";
}
template <typename T>
inline string dbg_format(vector<T>& vec) {
  string str = "[ ";
  for (T x : vec) {
    str += dbg_format(x);
    str += " ";
  }
  str += "] ";
  return str;
}
template <typename T>
inline string dbg_format(T x) {
  return to_string(x);
}

#define GET_MACRO_VAR(_1, _2, _3, _4, NAME, ...) NAME
#define dbg(...) GET_MACRO_VAR(__VA_ARGS__, dbg4, dbg3, dbg2, dbg1)(__VA_ARGS__)

#define dbg1(x) cerr << #x << " = " << dbg_format(x) << '\n';
#define dbg2(x, y)                              \
  cerr << #x << " = " << dbg_format(x) << '\n'; \
  cerr << #y << " = " << dbg_format(y) << '\n';
#define dbg3(x, y, z)                           \
  cerr << #x << " = " << dbg_format(x) << '\n'; \
  cerr << #y << " = " << dbg_format(y) << '\n'; \
  cerr << #z << " = " << dbg_format(z) << '\n';
#define dbg4(x, y, z, w)                        \
  cerr << #x << " = " << dbg_format(x) << '\n'; \
  cerr << #y << " = " << dbg_format(y) << '\n'; \
  cerr << #z << " = " << dbg_format(z) << '\n'; \
  cerr << #w << " = " << dbg_format(w) << '\n';

template <typename T>
void dbg_var(T& x) {
  cerr << dbg_format(x) << '\n';
}
template <typename T, typename... Types>
typename enable_if<sizeof...(Types)>::type dbg_var(T& x, Types&... y) {
  cerr << dbg_format(x) << '\n';
  dbg_var(y...);
}

#define GET_MACRO_ARRAY(_1, _2, NAME, ...) NAME
#define dbgarr(...) GET_MACRO_ARRAY(__VA_ARGS__, dbgarr2, dbgarr1)(__VA_ARGS__)
#define dbgarr1(x)                \
  cerr << #x << " :\n=======\n";  \
  for (auto y : x)                \
    cerr << dbg_format(y) << " "; \
  cerr << '\n';
#define dbgarr2(a, n)                \
  cerr << #a << " :\n=======\n";     \
  for (int i = 0; i < n; i++)        \
    cerr << dbg_format(a[i]) << " "; \
  cerr << '\n';
