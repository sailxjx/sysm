// Generated by CoffeeScript 1.3.3
(function() {
  var getBoardUrl, loadBoards;

  loadBoards = function() {
    return $('.board').each(function() {
      var bUrl, bd;
      bd = $(this).attr('board');
      if (bd) {
        bUrl = getBoardUrl($(this).attr('board'));
        $(this).load(bUrl);
        if (!$(this).attr('target-url')) {
          $(this).attr('target-url', bUrl);
        }
      }
      $(this).mouseenter(function() {
        if ($(this).hasClass('bp')) {
          return $(this).addClass('board-hover');
        }
      });
      return $(this).mouseleave(function() {
        return $(this).removeClass('board-hover');
      });
    });
  };

  getBoardUrl = function(name) {
    return "http://sysm.local.com/board/" + name;
  };

  loadBoards();

}).call(this);
