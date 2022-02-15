// The public key can be found in the Stripe Dashboard

export const InitCheckout = {
  mounted() {
    const successCallback = paymentIntent => { this.pushEvent('paymentSuccess', paymentIntent) }
    init(this.el, successCallback)
  }
}

const init = (form, successCallback) => {
const stripe = Stripe('pk_test_51KMjftEhbwcgc0l8C3th3MBwVv3XwHPYNugpBx9mCU7a5MhBWGcWLZTkZhupARsH4ImjO7J636QLcihA9DFZ3n4900vCEJGpXW')
const clientSecret = form.dataset.secret

  // Create an instance of Elements.
  var elements = stripe.elements();

  // Create an instance of the card Element.
  var card = elements.create('card', {style: style});

  // Add an instance of the card Element into the `card-element` <div>.
  card.mount('#card-element');

  // Handle real-time validation errors from the card Element.
  card.on('change', function(event) {
    var displayError = document.getElementById('card-errors');
    if (event.error) {
      displayError.textContent = event.error.message;
    } else {
      displayError.textContent = '';
    }
  });

  // Handle form submission.
  form.addEventListener('submit', function(event) {
    event.preventDefault()

    stripe.confirmCardPayment(clientSecret, {
      payment_method: {
        card: card
      }
    }).then(function(result) {
      if (result.error) {
        // Show error to your customer (e.g., insufficient funds)
        console.log(result.error.message);
      } else {
        // The payment has been processed!
        if (result.paymentIntent.status === 'succeeded') {
          // Show a success message to your customer
          successCallback(result.paymentIntent)
        }
      }
    })
  })
}

// Custom styling can be passed to options when creating an Element.
// (Note that this demo uses a wider set of styles than the guide below.)
const style = {
  base: {
    color: '#32325d',
    fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
    fontSmoothing: 'antialiased',
    fontSize: '16px',
    '::placeholder': {
      color: '#aab7c4'
    }
  },
  invalid: {
    color: '#fa755a',
    iconColor: '#fa755a'
  }
}