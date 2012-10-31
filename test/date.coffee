Date.prototype.format = (format)->
    o =
        "y+": this.getFullYear() # get full year (2012)
        "M+": this.getMonth() + 1 # get month (10)
        "d+": this.getDate() # get date (31)
        "h+": this.getHours() # get hours (11)
        "m+": this.getMinutes() # get minutes (31)
        "s+": this.getSeconds() # get seconds (59)
    for i of o
        if new RegExp("(" + i + ")").test format
            format = format.replace RegExp.$1, o[i]
    format

d = new Date(1351652241000)
console.log d.format('yyyy-MM-dd h:mm:s')
