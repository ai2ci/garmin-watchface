run:
	monkeydo SimpleAnalog.prg fenix6pro 

watch:
	find .  -name '*.[xm][mc]*' | entr sh -c 'monkeyc -d fenix6pro -f monkey.jungle -o SimpleAnalog.prg -y ../watch-face/developer_key ; echo "compiled"'