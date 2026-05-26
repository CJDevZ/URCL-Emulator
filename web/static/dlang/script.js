const fileLoader = document.getElementById('fileLoader');
let editor = ace.edit("editor");

editor.setOptions({
    enableBasicAutocompletion: true,
    enableLiveAutocompletion: true,
    enableSnippets: false
});
editor.setTheme("ace/theme/twilight")
editor.session.on('change', saveToLocal);

let consoleOutput = document.getElementById('console-output');

document.addEventListener('DOMContentLoaded', () => {
    const savedCode = localStorage.getItem('dlang_code');
    if (savedCode) {
        editor.setValue(savedCode, -1);
    }
});

async function uploadCode() {
    const code = editor.getValue();

    try {
        const response = await fetch(`dlang/compile`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(code)
        });

        if (!response.ok) {
            consoleOutput.textContent = "Failed to Compile";
            response.text().then(value => {
                editor.session.setAnnotations(JSON.parse(value))
                //editor.session.setAnnotations([{"row":2,"text":"Test Error","type":"error"}]);
            });
            return;
        }

        response.text().then(value => consoleOutput.textContent = value);
        editor.session.setAnnotations([])
    } catch (error) {
        consoleOutput.textContent = "Upload failed: " + error.message;
    }
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
    anchor.download = 'program.dlang';
    anchor.href = window.URL.createObjectURL(blob);
    anchor.click();
}

function saveToLocal() {
    const code = editor.getValue();
    localStorage.setItem('dlang_code', code);
}