/*
 var port = null;
 try {
 app = chrome.extension.connect();
 } catch(e) {
 console.log("Oops..might be incognito mode:" + e);
 }
 if(!port) {
 app.postMessage({request: "fetchReviews"});
 }
 */

YUI().use("node",

  function(Y) {

    var itemUrl;
    var itemId;

    /**
     * Get the session
     * @param session
     */
    function setSession(session) {
      console.log(session);
    }
    chrome.extension.sendRequest({'action' : 'getSession'}, setSession);

    function reviewPosted(response) {

      if (response === null) {
        return
      }

      var review = Y.one('li#review_'+response['review_id']);
      var span = review.one('a[rel='+response['vote_type']+']+span');
      if (span === null) {
        var li = review.one('li.'+response['vote_type']);
        span = Y.Node.create('<span>(0)</span>');
        li.append(span);
      }
      var value = parseInt(span.getContent().replace('(', ''));
      value+=1;
      span.setContent('('+value+')')
    }

    function postReview() {

      review = Y.one('li#review_'+this['vote']['review_id']);
      counts = review.all('a[rel=tmi]+span, a[rel=fos]+span, a[rel=ins]+span');
      if (counts.isEmpty()) {
        this['vote']['text'] = review.one('p.review_comment').getContent();
        this['reviewer'] = {
          reviewer_id: this['vote']['reviewer_id'],
          name: review.one('a.reviewer_name').getContent(),
          location: review.one('div.reviewer-details p.reviewer_info:last-child').getContent()
        }
      }

      chrome.extension.sendRequest({'action' : 'postReview', 'params' : this}, reviewPosted);
    }

    var itemIdNode = Y.one('meta[property="og:url"]');
    itemUrl = itemIdNode.getAttribute('content');
    if (itemUrl.match(/\/([^\/]+)$/)) {
      itemId = RegExp.$1
    }

    var allIds = [];

    /**
     * Find reviews and add new negative choices
     */
    Y.all('div.rateReview ul').each(function(node) {

      //parse item_id review_id and reviewer_id
      var reviewNode = node.ancestor('li.review');
      var reviewId = undefined;
      if (reviewNode.getAttribute('id').match(/^review_(.+)$/)) {
        reviewId = RegExp.$1
      }
      allIds.push(reviewId);

      var reviewerNode = reviewNode.one('p.reviewer_info a');
      var reviewerId = undefined;
      if (reviewerNode.getAttribute('href').match(/^\/user_details\?userid=(.+)$/)) {
        reviewerId = RegExp.$1
      }

      //create our nodes
      if (reviewId !== undefined && reviewerId !== undefined) {

        //TODO DRY this

        var insane = Y.Node.create('<li class="ins smaller"><a href="#" rel="ins"><span><strong>Insane!</strong></span></a></li>');
        Y.on("click", postReview, insane, { 'vote' : {'url': itemUrl,
                                                      'item_id': itemId,
                                                      'review_id': reviewId,
                                                      'reviewer_id': reviewerId,
                                                      'vote_type': 'ins' }}
            );
        node.append(insane);

        var fos = Y.Node.create('<li class="fos smaller"> <a href="#" rel="fos"><span><strong>Full of Shit!</strong></span></a></li>');
        Y.on("click", postReview, fos, { 'vote' : {'url': itemUrl,
                                                  'item_id': itemId,
                                                  'review_id': reviewId,
                                                  'reviewer_id': reviewerId,
                                                  'vote_type': 'fos' }}
            );
        node.append(fos);

        var tmi = Y.Node.create('<li class="tmi smaller"> <a href="#" rel="tmi"><span><strong>Nobody Cares!</strong></span></a></li>');
        Y.on("click", postReview, tmi, {'vote' : {'url': itemUrl,
                                                 'item_id': itemId,
                                                 'review_id': reviewId,
                                                 'reviewer_id': reviewerId,
                                                 'vote_type': 'tmi' }}
            );
        node.append(tmi);
      }

    });

    /**
     * Get the counters
     */
    function showReviews(response) {
      response.forEach(function(element) {

        var reviewNode = Y.one('li#review_'+element['review_id']);

        ['ins', 'tmi', 'fos'].forEach(function(type){
          var value = element['votes'][type];
          if (value !== undefined) {
            var childNode = reviewNode.one('a[rel='+type+']');
            var span = Y.Node.create('<span>('+value+')</span>');
            childNode.get('parentNode').append(span);
          }
        });

      });
    }
    chrome.extension.sendRequest({'action' : 'fetchReviews', 'params' : {'reviewIds':allIds}}, showReviews);

  }
);
