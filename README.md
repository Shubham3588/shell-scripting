# shell-scripting


Sed editor
# Sed with -i edit the file
# sed without -i will print the change on output

# -e is for multiple conditions in sed command
# -e cond1 -e con2

# Search and Replace / Substitute

sed -i -e 's/root/ROOT/g' -e 's/admin/ADMIN/g' sample.txt

# Delete Lines
sed -i -e '1d' -e '/root/ d' sample.txt

# Add Lines
sed -i -e '1 i Hello World' sample.txt
sed -i -e '/root/ i Hello World' sample.txt
sed -i -e '1 a Hello Word' sample.txt
sed -i -e '1 c Hello Word' sample.txt