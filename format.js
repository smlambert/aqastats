var fs = require('fs');
const myArgs = process.argv.slice(2);
const group = myArgs[1];
function run() {
    var stats = JSON.parse(fs.readFileSync(myArgs[0]));
    var time=parseInt(stats.testListTime[0]) / 1000 / 60 / 60
    var count=0
    for (var i = 0; i < stats.testLists.length; i++) {
        var list = stats.testLists[i]

        for (var j = 0; j < list.length; j++) {
            if (list[j].avgDuration)
                count++
        }
    }
    console.log()
    console.log("### ", group);
    console.log(" Execution time for ", count, " test targets: ", time.toFixed(2), " hours");
    console.log("<details><summary>Test target details</summary>")
    console.log()
    for (var i = 0; i < stats.testLists.length; i++) {
        var list = stats.testLists[i]
        console.log("| Test Target Name | Time |")
        console.log("| --- | --- |")
        for (var j = 0; j < list.length; j++) {
            if (list[j].avgDuration)
                console.log("|", list[j]._id, "|", parseInt(list[j].avgDuration).toFixed(2), " ms|",);
        }
    }
    console.log("</details>")
    console.log ()
    console.log ("---")
}
run()
