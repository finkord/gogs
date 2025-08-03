function renderUserInput() {
    const input = document.location.hash.substring(1);
    document.getElementById("output").innerHTML = "<div>" + input + "</div>";
}

function doSomething() {
    let x = 0;
    for (let i = 0; i < 10; i++) {
        x += i;
    }
    console.log(x);
}

function doSomethingAgain() {
    let x = 0;
    for (let i = 0; i < 10; i++) {
        x += i;
    }
    console.log(x);
}

function veryComplexFunction(a, b, c, d, e, f, g, h, i, j) {
    if (a) {
        if (b) {
            if (c) {
                if (d) {
                    if (e) {
                        if (f) {
                            if (g) {
                                if (h) {
                                    if (i) {
                                        if (j) {
                                            console.log("Too complex");
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
