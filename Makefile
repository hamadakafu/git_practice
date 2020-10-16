chore-hoge:
	echo "chore-hoge" >> hoge
	git add hoge
	git commit -m "chore(hoge): chore-hoge"
	git push

fix-hoge:
	echo "fix-hoge" >> hoge
	git add hoge
	git commit -m "fix(hoge): fix-hoge"
	git push

fix-fuga:
	echo "fix-fuga" >> fuga
	git add fuga
	git commit -m "fix(fuga): fix-fuga"
	git push

feat-hoge:
	echo "feat-hoge" >> hoge
	git add hoge
	git commit -m "feat(hoge): feat-hoge"
	git push

feat-fuga:
	echo "feat-fuga" >> fuga
	git add fuga
	git commit -m "feat(fuga): feat-fuga"
	git push

breaking-hoge:
	echo "BREAKING CHANGE hoge" >> hoge
	git add hoge
	git commit -m "feat(hoge): breaking-hoge" -m "BREAKING CHANGE: this is commit message body"
	git push

breaking-fuga:
	echo "BREAKING CHANGE fuga" >> fuga
	git add fuga
	git commit -m "feat(fuga): breaking-fuga" -m "BREAKING CHANGE: this is commit message body"
	git push

breaking-fuga-ok:
	echo "BREAKING CHANGE fuga" >> fuga
	git add fuga
	git commit -m "feat(fuga)!: breaking-fuga"
	git push

fix-hoge-make-dependencies:
	echo "fix-hoge 1" >> hoge
	git add hoge
	git commit -m "fix(hoge): fix-hoge 1"
	echo "fix-hoge 2" >> hoge
	git add hoge
	git commit -m "fix(hoge): fix-hoge 2"
	git push

