#include <algorithm>
#include <iostream>
#include <string>
#include <type_traits>
#include <vector>
using std::cerr, std::string, std::to_string, std::pair, std::tuple,
    std::vector, std::enable_if;

#define id(x)                                              \
  string str = #x;                                         \
  cerr << str << " : \n";                                  \
  for (int i = 0; i != str.length() + 2; ++i) cerr << "-"; \
  cerr << '\n';
#define line() cerr << "Line " << __LINE__ << " : ";
#define n(x) \
  for (int i = 0; i < x; i++) cerr << '\n';

template <typename T>
concept Container = requires(T t) { t.size(); };
template <typename T>
  requires(!Container<T>)
inline string dbg_format(T x) {
  return to_string(x);
}
inline string dbg_format(const bool& x) {
  return (x ? "true" : "false");
}
inline string dbg_format(const char& x) {
  string formatted_string = "'";
  formatted_string.push_back(x);
  formatted_string.push_back('\'');
  return formatted_string;
}
inline string dbg_format(const string& x) {
  string formatted_string = "";
  for (char c : x) {
    if (c == '\n') {
      formatted_string += "\\n";  // add two characters: backslash + n
    } else {
      formatted_string += c;
    }
  }
  return "\"" + formatted_string + "\"";
}
template <typename A, typename B>
inline string dbg_format(const pair<A, B>& x) {
  return "(" + dbg_format(x.first) + ", " + dbg_format(x.second) + ")";
}
template <typename Tuple, std::size_t Index>
void tuple_to_string_helper(const Tuple& tpl, std::string& result) {
  if constexpr (Index < std::tuple_size_v<Tuple>) {
    if (result != "(")
      result += ", ";  // Add separator if not the first element
    result += dbg_format(std::get<Index>(tpl));
    tuple_to_string_helper<Tuple, Index + 1>(tpl, result);
  }
}
template <typename... Args>
std::string dbg_format(const std::tuple<Args...>& tpl) {
  std::string result = "(";
  tuple_to_string_helper<std::tuple<Args...>, 0>(tpl, result);
  return result + ")";
}
template <Container T>
inline string dbg_format(const T& container) {
  string str = "[ ";
  for (auto elt : container) {
    str += dbg_format(elt);
    str += ", ";
  }
  if (container.size() != 0) {
    str.pop_back();
    str.pop_back();
  }
  str += " ]";
  return str;
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

#define GET_MACRO_ARRAY(_1, _2, _3, NAME, ...) NAME
#define dbgarr(...) \
  GET_MACRO_ARRAY(__VA_ARGS__, dbgarr3, dbgarr2, dbgarr1)(__VA_ARGS__)
#define dbgarr1(x)                                      \
  id(a) for (auto y : x) cerr << dbg_format(y) << ", "; \
  cerr << '\n';
#define dbgarr2(a, n)                                    \
  id(a) for (int i = 0; i < n; i++) cerr << a[i] << " "; \
  cerr << '\n';
#define dbgarr3(a, n, m)                              \
  id(a) for (int i = 0; i < n; i++) {                 \
    for (int j = 0; j != m; ++j) cerr << a[i] << " "; \
    cerr << '\n';                                     \
  }
