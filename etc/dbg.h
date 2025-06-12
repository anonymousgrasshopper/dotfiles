#include <algorithm>
#include <cstring>
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
inline void n(uint lines = 1) {
  for (uint i = 0; i < lines; i++) cerr << '\n';
}

template <typename T>
concept Iterable = requires(T t) {
  std::begin(t);
  std::end(t);
};
template <typename T>
  requires(!Iterable<T>)
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
      formatted_string += "\\n";
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
template <Iterable T>
inline string dbg_format(const T& container) {
  string str = "[ ";
  for (auto&& elt : container) {
    str += dbg_format(elt) + ", ";
  }
  if (!container.empty()) str.pop_back(), str.pop_back();
  return str + " ]";
}

#define dbg(...) dbg_expand(#__VA_ARGS__, __VA_ARGS__)
template <typename T>
void dbg_single(const char* name, const T& val) {
  cerr << name << " = " << dbg_format(val) << '\n';
}
inline void dbg_expand(const char*) {}  // base case for zero args
template <typename T, typename... Args>
void dbg_expand(const char* names, const T& value, const Args&... args) {
  const char* comma = strchr(names, ',');
  if (!comma) {
    dbg_single(names, value);
  } else {
    std::string name(names, comma);
    dbg_single(name.c_str(), value);
    while (*comma == ',' || *comma == ' ') ++comma;  // skip commas/spaces
    dbg_expand(comma, args...);
  }
}

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
