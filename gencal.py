from calendar import Calendar
import sys
import os

cal = Calendar()
WEEKFILE = "weeks.tex"
open(WEEKFILE, "w").close() # clears WEEKFILE
DAYKEYS = ["da","db","dc","dd","de","df","dg"]
MONTHNAMES = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

def printweek(week):
    with open(WEEKFILE, "a+") as outfile:
        attr = []
        for i in range(7):
            d = DAYKEYS[i]
            attr.append("{}={}".format(d, week[d]))
        for s in ["curmonth", "newmonth", "newday"]:
            attr.append("{}={}".format(s, week[s]))
        attr = ", ".join(attr)
        outfile.write("\weekpage{{ {0} }}\n".format(attr))

def numtoname(num):
    return MONTHNAMES[(num - 1) % 12]

def printmonth(year, month, first=False):
    weeks = cal.monthdatescalendar(year, month)
    curweek = {}
    # Juggling to avoid duplicate weeks.
    # The first week of the month shouldn't be printed
    # if the week started in the preceding month,
    # except if the month is the first of the calendar.
    if not first and weeks[0][0].month != month:
        startweek = 1
    else:
        startweek = 0
    for j in range(startweek, len(weeks)):
        curmonthnum = weeks[j][0].month
        curmonth = numtoname(curmonthnum)
        curweek["curmonth"] = curmonth
        curweek["newmonth"] = "Error"
        curweek["newday"] = 0
        new = 0
        for r in range(0,7):
            today = weeks[j][r]
            curweek[DAYKEYS[r]] = today.day
            if curmonthnum != today.month and not new:
                new = 1
                curweek["newmonth"] = numtoname(today.month)
                curweek["newday"] = r + 1
        printweek(curweek)

def printweeks(year, firstmonth, lastmonth, first=False):
    printmonth(year, firstmonth, first)
    for i in range(firstmonth + 1, lastmonth + 1):
        printmonth(year, i)

if __name__ == "__main__":
    printweeks(2018, 9, 12, first=True)
    printweeks(2019, 1, 9)
