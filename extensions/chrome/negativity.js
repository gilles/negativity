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
      chrome.extension.sendRequest({'action' : 'postReview', 'params' : this}, reviewPosted);
    }

    /**
     * Find reviews and add new negative choices
     */
    Y.all('div.rateReview ul').each(function(node) {

      var insane = Y.Node.create('<li class="insane smaller"><a href="#" rel="insane"><span><strong>Insane!</strong></span></a></li>');
      Y.on("click", postReview, insane, { 'item_id': '123', 'reviewer_id': '321', 'vote': '0' });
      node.append(insane);

      var bs = Y.Node.create('<li class="bs smaller"> <a href="#" rel="bs"><span><strong>Full of Shit!</strong></span></a></li>');
      Y.on("click", postReview, bs, { 'item_id': '123', 'reviewer_id': '321', 'vote': '1' });
      node.append(bs);

      var tmi = Y.Node.create('<li class="tmi smaller"> <a href="#" rel="tmi"><span><strong>Nobody Cares!</strong></span></a></li>');
      Y.on("click", postReview, bs, { 'item_id': '123', 'reviewer_id': '321', 'vote': '2' });
      node.append(tmi);

    });

  }
);

function showReviews(reviews) {
  console.log(reviews);
}

function setSession(session) {
  console.log(session);
}

chrome.extension.sendRequest({'action' : 'getSession'}, setSession);
