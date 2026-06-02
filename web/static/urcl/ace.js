const instructions = ("ADD|RSH|LOD|STR|BGE|NOR|SUB|JMP|MOV|NOP|IMM|LSH|INC|DEC|NEG|AND|OR|NOT|XNOR|XOR|NAND|BRL|BRG|BRE|BNE|BOD|BEV|BLE|BRZ|BNZ|BRN|BRP|PSH|POP|CAL|RET|HLT|CPY|BRC|BNC|MLT|UMLT|SUMLT|DIV|SDIV|MOD|BSR|BSL|SRS|BSS|SBRL|SBRG|SBLE|SBGE|SETE|SETNE|SETG|SETL|SETGE|SETLE|SETC|SETNC|SSETG|SSETL|SSETGE|SSETLE|LLOD|LSTR|ABS|IN|OUT|DW")

ace.define("ace/mode/urcl_highlight_rules", ["require", "exports", "module", "ace/lib/oop", "ace/mode/text_highlight_rules"], function (require, exports, module) {
  var oop = require("ace/lib/oop")
  var TextHighlightRules = require("ace/mode/text_highlight_rules").TextHighlightRules

  function URCLHighlightRules () {

    this.$rules = {
      start: [
        {
            // Opcodes / Instructions
            token: "keyword.control",
            regex: "\\b(" + instructions + ")\\b",
            caseInsensitive: true
        },
        {
            // Registers: R1, R2, $0, $1, etc.
            token: "variable.parameter",
            regex: "\\b(R\\d+|\\$\\d+|PC|SP|MSB)\\b",
            caseInsensitive: true
        },
        {
            // Preprocessor directives: @define, @import, etc.
            token: "keyword.preprocessor",
            regex: "@[a-zA-Z_\\d]+"
        },
        {
            // Highlights the @define and the following name separately
            token: ["keyword.preprocessor", "text", "variable.constant"],
            regex: "(@define)(\\s+)([A-Z_\\d]+)"
        },
        {
            // Labels: .loop, .main
            token: "entity.name.function",
            regex: "^\\s*\\.\\w+"
        },
        {
            // Numbers: 0x1F, 0b101, 123
            token: "constant.numeric",
            regex: "\\b(0x[0-9a-fA-F]+|0b[01]+|\\d+)\\b"
        },
        {
            // Comments: # or ;
            token: "comment",
            regex: "(//.*|#.*|;.*)"
        }
      ]
    }
  }
  oop.inherits(URCLHighlightRules, TextHighlightRules);
  exports.URCLHighlightRules = URCLHighlightRules
})

ace.define("ace/mode/urcl", ["require", "exports", "module", "ace/lib/oop", "ace/mode/text", "ace/mode/urcl_highlight_rules"], function (require, exports, module) {
  var oop = require("ace/lib/oop")
  var TextMode = require("ace/mode/text").Mode
  var URCLHighlightRules = require("ace/mode/urcl_highlight_rules").URCLHighlightRules

  function Mode () {
    this.HighlightRules = URCLHighlightRules
  }

  oop.inherits(Mode, TextMode);

  (function () {
    this.$id = "ace/mode/urcl"
  }).call(Mode.prototype)

  exports.Mode = Mode
})

editor.session.setMode("ace/mode/urcl")
editor.completers = [{
  getCompletions: function(editor, session, pos, prefix, callback) {
    if (session.$mode.$id !== "ace/mode/urcl") callback(null, []);

    let completions = [];

    var line = session.getLine(pos.row);
    var textBeforePrefix = line.substring(0, pos.column - prefix.length)

    if (textBeforePrefix.trim() == "") {
      const instructions = ("ADD|RSH|LOD|STR|BGE|NOR|SUB|JMP|MOV|NOP|IMM|LSH|INC|DEC|NEG|AND|OR|NOT|XNOR|XOR|NAND|BRL|BRG|BRE|BNE|BOD|BEV|BLE|BRZ|BNZ|BRN|BRP|PSH|POP|CAL|RET|HLT|CPY|BRC|BNC|MLT|UMLT|SUMLT|DIV|SDIV|MOD|BSR|BSL|SRS|BSS|SBRL|SBRG|SBLE|SBGE|SETE|SETNE|SETG|SETL|SETGE|SETLE|SETC|SETNC|SSETG|SSETL|SSETGE|SSETLE|LLOD|LSTR|ABS|IN|OUT").split("|")

      for (let instr of instructions) {
        completions.push({
          caption: instr,
          value: instr,
          meta: "instruction"
        })
      }

      callback(null, completions)
    } else {
      const fullText = session.getValue();
      const localCompletions = [];

      const labelRegex = /^\s*(\.\w+)/gm;
      let match;
      while ((match = labelRegex.exec(fullText)) != null) {
        localCompletions.push({
          caption: match[1],
          value: match[1],
          meta: "label"
        })
      }

      const defineRegex = /^\s*@define\s+([A-Z_0-9]+)/gim;
      while ((match = defineRegex.exec(fullText)) != null) {
        localCompletions.push({
          caption: match[1],
          value: match[1],
          meta: "define"
        })
      }

      completions = Array.from(new Set(localCompletions.map(a => a.value)))
        .map(value => localCompletions.find(a => a.value === value));

      callback(null, completions)
    }
  }
}]