import locale
from calendar import Calendar

from config import CONF
from geninclude import gen

cal = Calendar()
WEEKFILE = "weeks.tex"
LOCFILE = "localisation.tex"
SUPPORTFILE = "padder-support.tex"
DAYKEYS = ["a", "b", "c", "d", "e", "f", "g"]


def get_month_names():
    abbr = CONF["Preferences"]["months_abbreviated"] == "True"
    if abbr:
        months = range(locale.ABMON_1, locale.ABMON_12 + 1)
    else:
        months = range(locale.MON_1, locale.MON_12 + 1)

    return [locale.nl_langinfo(x).lower() for x in months]


def get_day_names():
    wrongweek = False
    abbr = CONF["Preferences"]["week_days_abbreviated"] == "True"
    if abbr:
        days = list(range(locale.ABDAY_1, locale.ABDAY_7 + 1))
    else:
        days = list(range(locale.DAY_1, locale.DAY_7 + 1))

    if not wrongweek:
        days = days[1:] + days[0:1]

    return [locale.nl_langinfo(x) for x in days]


def write_localisation():
    weekdays = get_day_names()
    with open(LOCFILE, "w") as locfile:
        for day, key in zip(weekdays, DAYKEYS):
            # \newcommand{\wkdaya}{mon}
            tex = r"\newcommand{\wkday" + key + "}{" + day + "}\n"
            locfile.write(tex)

        locfile.write(
            r"\newcommand{\firstlabel}{"
            + CONF["Localisation"]["first_semester_label"]
            + "}"
        )
        locfile.write(
            r"\newcommand{\secondlabel}{"
            + CONF["Localisation"]["second_semester_label"]
            + "}"
        )


def printweek(week):
    with open(WEEKFILE, "a+") as outfile:
        attr = []
        for i in range(7):
            d = DAYKEYS[i]
            attr.append("d{}={}".format(d, week[d]))
        for s in ["curmonth", "newmonth", "newday"]:
            attr.append("{}={}".format(s, week[s]))
        attr = ", ".join(attr)
        outfile.write("\weekpage{{ {0} }}\n".format(attr))  # noqa: W605


def numtoname(num):
    month_names = get_month_names()
    return month_names[(num - 1) % 12]


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
    n = 0
    for j in range(startweek, len(weeks)):
        curmonthnum = weeks[j][0].month
        curmonth = numtoname(curmonthnum)
        curweek["curmonth"] = curmonth
        curweek["newmonth"] = "Error"
        curweek["newday"] = 0
        new = 0
        for r in range(0, 7):
            today = weeks[j][r]
            curweek[DAYKEYS[r]] = today.day
            if curmonthnum != today.month and not new:
                new = 1
                curweek["newmonth"] = numtoname(today.month)
                curweek["newday"] = r + 1
        printweek(curweek)
        n += 1
    return n


def printweeks(year, firstmonth, lastmonth, first=False):
    n = printmonth(year, firstmonth, first)  # side-effects!
    for i in range(firstmonth + 1, lastmonth + 1):
        n += printmonth(year, i)

    return n


if __name__ == "__main__":
    open(WEEKFILE, "w").close()  # clears WEEKFILE

    locale.setlocale(locale.LC_ALL, "")
    month_names = get_month_names()
    write_localisation()

    year = int(CONF["Planner"]["first_year"])
    wk = printweeks(year, 9, 12, first=True)
    wk += printweeks(year + 1, 1, 9)

    number_pages = 1 + 4 + wk * 2
    padding = 8 - (number_pages % 8)
    curly = ",".join(["{}"] * padding)
    tex = r"\includepdf[pages={{},-," + curly + r"}]{halved.pdf}"
    with open(SUPPORTFILE, "w") as sup:
        sup.write(tex)

    gen(number_pages + padding)
