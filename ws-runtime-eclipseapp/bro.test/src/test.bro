browser firefox edge {
	go "https://google.com"
	byName "search-bar" > searchBar
	byId "validate-button" > validateButton
	
	searchBar:first {
		fill "potato"
	}
	
	validateButton {
		click
	}
	
	wait 3000
	byName "results" > googleResults 
	
	googleResults:first {
		verify "https://fr.wikipedia.org/wikiPotato"
	}
}
