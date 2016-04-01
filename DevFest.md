Ruby/Js to Go

Simon Escobar
Dev at Elizabeth & Clarke
Co-Organizer of Golang Medellin
Member of MedellinJs
Member of Medellin.rb
Mentor at Rails Girls Medellin

Twitter @sescob27
Github sescobb27

What I like about Ruby
  Beautiful - Fancy
  ```ruby
    class Client < ActiveRecord::Base
      include User
      scope :with_active_discounts, -> { includes(:discounts).where(discounts: { status: true }) }
    end
    Class Discount
      scope :not_expired, lambda {
        where("\"discounts\".\"created_at\" < (now() + (\"discounts\".\"duration\" * 60 || 'seconds')::interval)")
      }
      def self.categories
        # ==========================================================================
        # SELECT DISTINCT "clients"."*", "discounts"."*"
        # FROM "clients"
        # LEFT OUTER JOIN "discounts"
        # ON "discounts"."client_id" = "clients"."id"
        # WHERE "discounts"."status" = 't'
        # AND ("discounts"."created_at" < (now() + ("discounts"."duration" * 60 || 'seconds')::interval))
        # ==========================================================================
        Client.select(:categories)
          .distinct
          .with_active_discounts
          .merge(Discount.not_expired)
          .map(&:categories).flatten.uniq
      end
    end
  ```
  Practical
  Developer Focused - Natural
  Balanced: Functional Programming with Imperative Programming
  ```ruby
    tokens = customers.map(&:mobiles).flatten.map(&:token)
    gcm = Gcm::Notification.instance
    response = gcm.send_notification(tokens, options)
  ```
  AND
  My first scripting language
  It helped me to be a better developer (TDD - BDD - REST - APIs - Human Focused Code - Best Practices - Read other's code - Git - Heroku)

What I like about Javascript (Not JQuery - Not React - Not Angular - Not Node)
  Practical
  Balanced: Functional Programming with Imperative Programming
  ```js
  var itemsSubtotal = _.reduce(_.pluck(orderItems, 'price'), (total, price) => { return total + price; }, 0);
  ```
  Can run in Browser and Server
  "Pispito" (ES6)

What Go is similar to Ruby/Js
  Practical
  ```Go
  import (
    "net/http"
  )
  func main() {
    server := http.NewServeMux()
    server.Handle("/css/",
        http.StripPrefix("/css/",
            http.FileServer(
                http.Dir("resources/css"))))
    server.Handle("/js/",
        http.StripPrefix("/js/",
            http.FileServer(
                http.Dir("resources/js"))))
    http.ListenAndServe(":3000", server)
  }
  ```
  ```Go
  func main() {
    server := http.NewServeMux()
    go func(tlsServer *ServeMux) {
        err := http.ListenAndServeTLS(":443", "cert.pem", "key.pem", tlsServer)
        if err != nil {
            panic(err)
        }
    }(server)
    http.ListenAndServe(":80", server)
  }
  ```
  `go build`
  `go get ...`
  `go test`
  Simple
    Just 25 keywords
      break        default      func         interface    select
      case         defer        go           map          struct
      chan         else         goto         package      switch
      const        fallthrough  if           range        type
      continue     for          import       return       var
    No Pointer Aritmetic
  Not as Fancy but more Fancy than C/C++/Java
  Balanced: "Functional Programming" with Imperative Programming
  ```Go
  type Promise interface {
    Then(func(value interface{}) Promise) Promise
  }

  type AsyncRequest struct {
    Promise
    body chan int64
  }

  func NewAsyncRequest() *AsyncRequest {
    return &AsyncRequest{
      body: make(chan int64),
    }
  }

  func (aReq *AsyncRequest) Then(chain func(value interface{}) Promise) Promise {
    return chain(<-aReq.body)
  }

  func (aReq *AsyncRequest) Get(path string) Promise {
    go func() {
      res, err := http.Get(path)
      defer res.Body.Close()
      if err != nil {
        fmt.Println("Fatal error ", err.Error())
        os.Exit(1)
      }
      // ... GET answet from res
      aReq.body <- answer
    }()
    return aReq
  }

  func main() {
    req := NewAsyncRequest()
    var wg sync.WaitGroup
    for i := 1; i <= 100; i++ {
      wg.Add(1)
      go func(r *AsyncRequest, iter int) {
        fmt.Println("Asynchronous Gets")
        r.Get("http://localhost:3000/odd").Then(func(response interface{}) Promise {
          fmt.Fprintf(os.Stdout, "(ODD) From Promise %d value => %v\n", iter, response)
          req2 := NewAsyncRequest()
          return req2.Get("http://localhost:3000/pair")
        }).Then(func(response interface{}) Promise {
          fmt.Fprintf(os.Stdout, "(PAIR) From Innert Promise %d value => %v\n", iter, response)
          wg.Done()
          return nil
        })
      }(req, i)
    }
    wg.Wait()
  }
  ```
  Monkey Patching
    "A monkey patch is a way to extend or modify the run-time code of dynamic languages without altering the original source code." - Wikipedia
      ```Go
      var auth = func(user string) bool {
          res, err := http.Get(authURL + "/" + user)
          return err == nil && res.StatusCode == http.StatusOK
      }
      func sayHi(user string) {
          if !auth(user) {
              fmt.Printf("unknown user %v\n", user)
              return
          }
          fmt.Printf("Hi, %v\n", user)
      }
      ```

      Test
      ```Go
      func TestSayHi() {
          auth = func(string) bool { return true }
          sayHi("John")

          auth = func(string) bool { return false }
          sayHi("John")
      }
      ```

Compiled vs Interpreted
  Types vs Duck Typing vs I don't know
  Go
    Strongly Styped
    Statically Typed
  Ruby
    Strongly Styped
    Duck Typing
    https://talks.golang.org/2013/go4python/img/duck.jpg
  Js
    Weakly Typed
      '1' - 1 === 0
      1 + '1' === '11'
      '1' + 1 === '11'
      '1' + 1 + 1 === '111'
      1 + 1 + '1' === '21'

    I don't know
      undefined
        typeof undefined === 'undefined';
        typeof blabla === 'undefined';
      object
        typeof {a:1} === 'object';
        typeof null === 'object';
        typeof [1, 2, 4] === 'object';
        typeof new Date() === 'object';
        typeof new Boolean(true) === 'object';
        typeof new Number(1) === 'object';
        typeof new String("abc") === 'object';
      boolean
        typeof true === 'boolean';
      number
        typeof 37 === 'number';
        typeof NaN === 'number';
        typeof Infinity === 'number';
      string
        typeof "" === 'string';

What I DON'T like about Ruby
  GIL - (Global Interpreted Lock)
  Typos
  No Method Error
What I DON'T like about Js
  Callback Hell (Concurrency Approach)
  Lack of Types
  Typos
  undefined is not a function
  Browser's Implementations of it
  Scopes (this)
  http://nodejsreactions.tumblr.com/post/71649072477/look-at-mah-new-framework-it-does-all-the

Inheritance
Prototypal-Inheritance
Composition

Performance
  DEMO TIME
  https://github.com/rakyll/boom
  Go
    boom -cpus=8 -n=10000 -c=100 http://localhost:5000/
  Node
    boom -cpus=8 -n=10000 -c=100 http://localhost:5001/
  Ruby
    boom -cpus=8 -n=10000 -c=100 http://localhost:5002/
