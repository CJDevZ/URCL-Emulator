ace.define("ace/mode/urcl_highlight_rules", ["require", "exports", "module", "ace/lib/oop", "ace/mode/text_highlight_rules"], function (require, exports, module) {
  var oop = require("ace/lib/oop")
  var TextHighlightRules = require("ace/mode/text_highlight_rules").TextHighlightRules
  
  function URCLHighlightRules () {
    var instructions = ("ADD|RSH|LOD|STR|BGE|NOR|SUB|JMP|MOV|NOP|IMM|LSH|INC|DEC|NEG|AND|OR|NOT|XNOR|XOR|NAND|BRL|BRG|BRE|BNE|BOD|BEV|BLE|BRZ|BNZ|BRN|BRP|PSH|POP|CAL|RET|HLT|CPY|BRC|BNC|MLT|UMLT|SUMLT|DIV|SDIV|MOD|BSR|BSL|SRS|BSS|SBRL|SBRG|SBLE|SBGE|SETE|SETNE|SETG|SETL|SETGE|SETLE|SETC|SETNC|SSETG|SSETL|SSETGE|SSETLE|LLOD|LSTR|ABS|IN|OUT")

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
            // Comments: // or # or ;
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

const fileLoader = document.getElementById('fileLoader');
let editor = ace.edit("editor")
editor.setTheme("ace/theme/twilight")
editor.session.setMode("ace/mode/urcl")
editor.session.on('change', saveToLocal);

document.addEventListener('DOMContentLoaded', () => {
    const savedCode = localStorage.getItem('urcl_code');
    if (savedCode) {
        editor.setValue(savedCode, -1);
    }
});

function uploadCode() {
    const text = editor.value;
    const blob = new Blob([text], { type: 'text/plain' });
    const anchor = document.createElement('a');
    anchor.download = 'program.urcl';
    anchor.href = window.URL.createObjectURL(blob);
    anchor.click();
}

function loadCode() {
    fileLoader.click();
}

fileLoader.addEventListener('change', function() {
    const file = this.files[0];
    if (!file) return;

    const reader = new FileReader();

    reader.onload = function(e) {
        const content = e.target.result;

        editor.setValue(content, -1);
        saveToLocal();
    }

    reader.readAsText(file);
});

function saveCode() {
    const text = editor.getValue();
    const blob = new Blob([text], { type: 'text/plain' });
    const anchor = document.createElement('a');
    anchor.download = 'program.urcl';
    anchor.href = window.URL.createObjectURL(blob);
    anchor.click();
}

function saveToLocal() {
    const code = editor.getValue();
    localStorage.setItem('urcl_code', code);
}