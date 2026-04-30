class StringUtils {
  static String stripHtml(String htmlString) {
    if (htmlString == null || htmlString.isEmpty) {
      return '';
    }

    // Replace <p> tags with newlines or spaces if needed, but for now just strip all tags
    String result = htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
    
    // Decode common entities
    result = result.replaceAll('&nbsp;', ' ');
    result = result.replaceAll('&amp;', '&');
    result = result.replaceAll('&lt;', '<');
    result = result.replaceAll('&gt;', '>');
    result = result.replaceAll('&quot;', '"');
    result = result.replaceAll('&#39;', "'");
    
    return result.trim();
  }
}
