from csv import reader

with open("4000Footers.csv", "r") as infile:
  mountains = reader(infile, delimiter=",")

  mount_arr = []
  for line in mountains:
    mount_arr.append(line[0])

  mount_arr.sort(key=len)

  for mount in mount_arr:
    print(mount)
