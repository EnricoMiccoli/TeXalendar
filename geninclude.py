OUTFILE = "inclusions.tex"
open(OUTFILE, "w").close() # clears 
seed = [4,1,8,5,2,3,6,7]
tmp = []
tmp += list(map(lambda x: repr(x), seed))
pages = 128

i = 8
while i < pages:
    seed = list(map(lambda x: x+8, seed))
    tmp += list(map(lambda x: repr(x), seed))
    i += 8

argument = ",".join(tmp)

with open(OUTFILE, "w") as outfile:
    outfile.write("\includepdf[pages={{{}}},nup=2x2]{{padded.pdf}}".format(argument))
