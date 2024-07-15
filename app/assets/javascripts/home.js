document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('search-input');
    const searchResults = document.getElementById('Dashboard-search-results');
  
    searchInput.addEventListener('input', function() {
      const searchValue = searchInput.value.trim();
  
      if (searchValue.length === 0) {
        searchResults.innerHTML = '';
        return;
      }
  
      fetch(`/search?query=${encodeURIComponent(searchValue)}`)
        .then(response => response.json())
        .then(data => {
          const results = data.slice(0, 5);
          const listItems = results.map(result => `<li>${result.company_name}</li>`).join('');
          const html = `<ul>${listItems}</ul>`;
          searchResults.innerHTML = html;
          searchResults.style.display = 'block';
        })
        .catch(error => {
          console.error('Error fetching search results:', error);
        });
    });

    document.addEventListener('click', function(event) {
        if (!searchResults.contains(event.target)) {
          searchResults.style.display = 'none';
        }
    });
  });
  