
foldername=$(basename $(pwd))

echo mkdir -p ~/tools
mkdir -p ~/tools

echo rm -f ~/tools/$foldername
rm -f ~/tools/$foldername

echo ln -s $(pwd) ~/tools/$foldername
ln -s $(pwd) ~/tools/$foldername

echo bash install-hyphendirs.bash ~/
bash install-hyphendirs.bash "$HOME"
