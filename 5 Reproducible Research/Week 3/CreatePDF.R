# Load packages
require(knitr)
require(markdown)

# Create .md, .html, and .pdf files
knit("PeerReview2.Rmd")
markdownToHTML('PeerReview2.md', 'PeerReview2.html', options=c("use_xhml"))
system("pandoc -s PeerReview2.html -o PeerReview2.pdf")