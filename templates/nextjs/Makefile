dev:
	npm run dev

initialize:
	git init .
	# It needs to go in an empty directory
	npx create-next-app@latest frontend \
		--ts \
		--tailwind \
		--eslint \
		--app \
		--src-dir \
		--use-npm
	mv frontend/* .
	rm -rf frontend
