// MathJax configuration for MkDocs Material theme
window.MathJax = {
  tex: {
    inlineMath: [["\\(", "\\)"]],
    displayMath: [["\\[", "\\]"]],
    processEscapes: true,
    processEnvironments: true
  },
  options: {
    ignoreHtmlClass: ".*|",
    processHtmlClass: "arithmatex"
  }
};

document.addEventListener("DOMContentLoaded", function() {
  // Initialize MathJax when the page loads
  if (typeof MathJax !== 'undefined') {
    MathJax.typesetPromise();
  }
}); 