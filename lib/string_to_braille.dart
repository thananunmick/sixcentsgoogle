Map<String, List<List<bool>>> dict = {
  'a': [[true, false, false, false, false, false]],
  'b': [[true, true, false, false, false, false]],
  'c': [[true, false, false, true, false, false]],
  'd': [[true, false, false, true, true, false]],
  'e': [[true, false, false, false, true, false]],
  'f': [[true, true, false, true, false, false]],
  'g': [[true, true, false, true, true, false]],
  'h': [[true, true, false, false, true, false]],
  'i': [[false, true, false, true, false, false]],
  'j': [[false, true, false, true, true, false]],
  'k': [[true, false, true, false, false, false]],
  'l': [[true, true, true, false, false, false]],
  'm': [[true, false, true, true, false, false]],
  'n': [[true, false, true, true, true, false]],
  'o': [[true, false, true, false, true, false]],
  'p': [[true, true, true, true, false, false]],
  'q': [[true, true, true, true, true, false]],
  'r': [[true, true, true, false, true, false]],
  's': [[false, true, true, true, false, false]],
  't': [[false, true, true, true, true, false]],
  'u': [[true, false, true, false, false, true]],
  'v': [[true, true, true, false, false, true]],
  'w': [[false, true, false, true, true, true]],
  'x': [[true, false, true, true, false, true]],
  'y': [[true, false, true, true, true, true]],
  'z': [[true, false, true, false, true, true]],
  ' ': [[false, false, false, false, false, false]],
  '1': [[true, false, false, false, false, false]],
  '2': [[true, true, false, false, false, false]],
  '3': [[true, false, false, true, false, false]],
  '4': [[true, false, false, true, true, false]],
  '5': [[true, false, false, false, true, false]],
  '6': [[true, true, false, true, false, false]],
  '7': [[true, true, false, true, true, false]],
  '8': [[true, true, false, false, true, false]],
  '9': [[false, true, false, true, false, false]],
  '0': [[false, true, false, true, true, false]],
  'startNum': [[false, false, true, true, true, true]],
  'endNum': [[false, false, false, false, true, true]], // only necessary if the next character is not a space or newline
  ',': [[false, true, false, false, false, false]],
  ';': [[false, true, true, false, false, false]],
  ':': [[false, true, false, false, true, false]],
  '.': [[false, true, false, false, true, true]],
  '?': [[false, true, true, false, false, true]],
  '!': [[false, true, true, false, true, false]],
  '\'': [[false, false, true, false, false, false]],
  'open quote': [[false, true, true, false, false, true]],
  'close quote': [[false, false, true, false, true, true]],
  '(': [[false, false, false, false, true, false], [true, true, false, false, false, true]],
  ')': [[false, false, false, false, true, false], [false, false, true, true, true, false]],
  '/': [[false, false, false, true, true, true], [false, false, true, true, false, false]],
  '-': [[false, false, true, false, false, true]],
  '\u{2014}' : [[false, false, false, false, false, true], [false, false, true, false, false, true]],
  '&': [[false, false, false, true, false, false], [true, true, true, true, false, true]],
  '*': [[false, false, false, false, true, false], [false, false, true, false, true, false]],
  '@': [[false, false, false, true, false, false], [true, false, false, false, false, false]],
  '©': [[false, false, false, true, true, false], [true, false, false, true, false, false]],
  '®': [[false, false, false, true, true, false], [true, true, true, false, true, false]],
  '™': [[false, false, false, true, true, false], [false, true, true, true, true, false]],
  '°': [[false, false, false, true, true, false], [false, true, false, true, true, false]],
  '%': [[false, false, false, true, false, true], [false, false, true, false, true, true]],
  '+': [[false, false, false, false, true, false], [false, true, true, false, true, false]],
  'minus': [[false, false, false, false, true, false], [false, false, true, false, false, true]],
  '=': [[false, false, false, false, true, false], [false, true, true, false, true, true]],
  '×': [[false, false, false, false, true, false], [false, true, true, false, false, true]],
  '÷': [[false, false, false, false, true, false], [false, false, true, true, false, false]],
  'grade 1 symbol indicator': [[false, false, false, false, true, true]],
  'capital letter indicator': [[false, false, false, false, false, true]],
};

/*
Grade 1 Braille (No Contraction)

Assumption:
- The text has no nested quotation

TODO:
- Handle Math (?)
*/
List<List<bool>> textToBraille(String text) {
  // TODO: Handle numbers
  // TODO: Handle Quotations
  // TODO: Handle hyphens (both short and long)
  List<List<bool>> ans = [];

  var isNowDigit = false;
  var onQuote = false;

  for(var i = 0; i < text.length; ++i){
    final codeUnit = text.codeUnitAt(i);

    if(65 <= codeUnit && codeUnit <= 90){
      ans.addAll((dict['capital letter indicator'] as List<List<bool>>));
      ans.addAll((dict[text[i].toLowerCase()] as List<List<bool>>));
    }else if(97 <= codeUnit && codeUnit <= 122){
      ans.addAll((dict[text[i]] as List<List<bool>>));
    }else if(codeUnit == '"'.codeUnitAt(0)){
      if(onQuote){
        onQuote = false;
        ans.addAll((dict['open quote'] as List<List<bool>>));
      }else{
        onQuote = true;
        ans.addAll((dict['close quote'] as List<List<bool>>));
      }
    }else if(48 <= codeUnit && codeUnit <= 57){
      if(isNowDigit){
        ans.addAll((dict[text[i]] as List<List<bool>>));
      }else{
        ans.addAll((dict['startNum'] as List<List<bool>>));
        ans.addAll((dict[text[i]] as List<List<bool>>));
        isNowDigit = true;

        if(i < text.length-1 && !isCharNumber(text[i+1]) && text[i+1] != ' '){
          ans.addAll((dict['endNum'] as List<List<bool>>));
          isNowDigit = false;
        }
        if(i == text.length || !isCharNumber(text[i+1])){
          isNowDigit = false;
        }
      }
    }else{
      ans.addAll((dict[text[i]] as List<List<bool>>));
    }
  }
  return ans;
}

// check if a character is number
bool isCharNumber(String s){
  return 48 <= s.codeUnitAt(0) && s.codeUnitAt(0) <= 57;
}