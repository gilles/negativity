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

YUI().use("node", "io-xdr", "json-parse", "json-stringify",
 
	function(Y) {

       /*
		Y.io.transport({ id: 'flash', src: 'http://yui.yahooapis.com/3.3.0/build/io/io.swf?stamp=' + new Date().valueOf().toString() });
		*/
		Y.io.header('Content-Type', 'application/json');
		
		function postReview(e) {

            e.halt();

			var request = Y.io('http://vivid-snow-285.heroku.com/vote', {

                method: "POST",
                data:   Y.JSON.stringify({
                            'post_id': this.post_id,
                            'reviewer_id': this.reviewer_id,
                            'vote': this.vote
                    }),                			    
                /*
    			xdr: {
    				use:'flash'
    			},
    			*/
    			on: {
    				success: function(id, o, a) {
 
            			var response = Y.JSON.parse(o.responseText);

            			console.log(o);
            
            			alert(o.responseText);
 
            		},
    				failure: function(id, o, a) {
            			Y.log("ERROR " + id + " " + a, "info");
            		}
    			}
    		});
		    
		};

        /**
         * Find reviews and add new negative choices
         */    
        Y.all('div.rateReview ul').each(function(node) {
            
            var insane = Y.Node.create('<li class="insane smaller"><a href="#" rel="insane"><span><strong>Insane!</strong></span></a></li>');
            Y.on("click", postReview, insane, { 'post_id': '123', 'reviewer_id': '321', 'vote': 'insane' });
            node.append(insane);
            
            var bs = Y.Node.create('<li class="bs smaller"> <a href="#" rel="bs"><span><strong>Full of Shit!</strong></span></a></li>');
            Y.on("click", postReview, bs, { 'post_id': '123', 'reviewer_id': '321', 'vote': 'bs' });
            node.append(bs);
            
            var tmi = Y.Node.create('<li class="tmi smaller"> <a href="#" rel="tmi"><span><strong>Nobody Cares!</strong></span></a></li>');
            Y.on("click", postReview, bs, { 'post_id': '123', 'reviewer_id': '321', 'vote': 'tmi' });
            node.append(tmi);

        });
 
         /**
          * Fetch new session + set csrf cookie / token
          */
          
        /*
		Y.on('io:xdrReady', function() {


		});
		*/
		
        /**
         * Fetch new session + set csrf cookie / token
         */
		var request = Y.io('http://vivid-snow-285.heroku.com/session', {
		    
			method: "GET",
			/*
			xdr: {
				use:'flash'
			},
			*/
			on: {
				success: function(id, o, a) {

        			var response = Y.JSON.parse(o.responseText);

        			console.log(o);
        			console.log(response);
		
                    /**
                     * Fetch new session + set csrf cookie / token
                     */
        			Y.io.header('X-CSRF-Token', response['X-CSRF-Token']);
		
        			alert(o.responseText);

        		},
				failure: function(id, o, a) {
        			Y.log("ERROR " + id + " " + a, "info", "example");
        		}
			}
		});
 
 
	}
);

function showReviews(reviews)
{
    alert(reviews);
}

chrome.extension.sendRequest({'action' : 'fetchReviews'}, showReviews);
