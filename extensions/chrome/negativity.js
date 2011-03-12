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

    function reviewPosted(response) {
      console.log(response);
    }

    function postReview() {

      //TODO get the text of the review
      //Actually getting the review_id / reviewer_id etc can get here
      //It will be more efficient

      chrome.extension.sendRequest({'action' : 'postReview', 'params' : this}, reviewPosted);
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

      var itemIdNode = Y.one('meta[property="og:url"]');
      var itemId = undefined
      if (itemIdNode.getAttribute('content').match(/\/(.+)$/)) {
        itemId = RegExp.$1
      }

      //create our nodes
      if (reviewId !== undefined && reviewerId !== undefined) {

        //TODO make a function out of this, including getting all info

        var insane = Y.Node.create('<li class="insane smaller"><a href="#" rel="insane"><span><strong>Insane!</strong></span></a></li>');
        Y.on("click", postReview, insane, { 'vote' : {'url': 'http://url',
                                                      'item_id': itemId,
                                                      'review_id': reviewId,
                                                      'reviewer_id': reviewerId,
                                                      'vote_type': '0' }}
            );
        node.append(insane);

        var bs = Y.Node.create('<li class="bs smaller"> <a href="#" rel="bs"><span><strong>Full of Shit!</strong></span></a></li>');
        Y.on("click", postReview, bs, { 'vote' : {'url': 'http://url',
                                                  'item_id': itemId,
                                                  'review_id': reviewId,
                                                  'reviewer_id': reviewerId,
                                                  'vote_type': '1' }}
            );
        node.append(bs);

        var tmi = Y.Node.create('<li class="tmi smaller"> <a href="#" rel="tmi"><span><strong>Nobody Cares!</strong></span></a></li>');
        Y.on("click", postReview, tmi, {'vote' : {'url': 'http://url',
                                                 'item_id': itemId,
                                                 'review_id': reviewId,
                                                 'reviewer_id': reviewerId,
                                                 'vote_type': '2' }}
            );
        node.append(tmi);
      }

    });

    /**
     * Get the session
     * @param session
     */
    function setSession(session) {
      console.log(session);
    }
    chrome.extension.sendRequest({'action' : 'getSession'}, setSession);

    /**
     * Get the counters
     */
    function showReviews(response) {
      console.log(response);
    }
    chrome.extension.sendRequest({'action' : 'fetchReviews', 'params' : {'reviewIds':allIds}}, showReviews);

  }
);
