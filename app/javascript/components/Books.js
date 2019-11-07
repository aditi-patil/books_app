import React from "react";
import { render } from "react-dom";
import axios from 'axios';
import InfiniteScroll from "react-infinite-scroll-component";
import {
  Card, CardImg, CardText, CardBody,
  CardTitle, CardSubtitle, Button, Container, Row, Col, Form, Input
} from 'reactstrap';

const style = {
  height: 30,
  border: "1px solid green",
  margin: 6,
  padding: 8
};

const PER_PAGE = 15
class Books extends React.Component {

    constructor(props){
        super(props)
        this.state = {
          allbooks: [],
          inputValue: '',
          books: props.books,
          page: 1
        }
        this.fetchMoreData = this.fetchMoreData.bind(this);
        this.filterList = this.filterList.bind(this);
    }

    componentDidMount(){
      // this.getBooksData()
    }

    fetchMoreData() {
      if (this.state.inputValue == 0) {
        axios.get(`/books?limit=${PER_PAGE*this.state.page}&offset=${this.state.books.length}`)
        .then(response => {
            console.log(response.data)
            this.setState({ 
              books: response.data.books,
              page: this.state.page + 1
            })
        })
        .catch(error => console.log(error))
      }
    }

    filterList = (event) => {

      if (event.target.value.length == 0) {
        this.setState({
          books: this.props.books,
          inputValue: event.target.value
        }) ;       
      }
      else {
        var searchtxt = event.target.value
        this.setState({ inputValue: searchtxt })
        axios.get(`/books?search=${event.target.value}`)
          .then(response => {
              console.log(response.data.books)
              debugger
              let books = response.data.books;
              this.setState({
                books: books,
                inputValue: searchtxt,
                page: 1
              });            
        })   

      }
    }

    getBooksData() {
      return (
        axios.get('/books?search=all')
          .then(response => {
              console.log(response.data)
              this.setState({ 
                allbooks: response.data.books
              })              
            })
          )
          .catch(error => console.log(error))
          
    }

    render() {
      var books= this.state.books.map((book, index) => {
          return (
            <Col sm="3" key={index} height="400px">
              <Card >
                <CardImg height="170px" src={book.cover_image} alt="Card image cap" />
                <CardBody height="230px">
                  <CardTitle>{book.title.substring(0, 20)}</CardTitle>
                  <CardSubtitle>{book.author.substring(0, 20)}</CardSubtitle>
                  <CardText>Published Date: {book.published_on} </CardText>
                </CardBody>
              </Card>
            </Col>

          )
      });

      return (
        <Container>
          <Input
              type="search"
              name="search"
              value={this.state.inputValue}
              placeholder="search placeholder"
              onChange={this.filterList}
            />
          <InfiniteScroll
            dataLength={this.state.books.length}
            next={this.fetchMoreData}
            hasMore={true}
            loader={<h4>Loading...</h4>}
          >
            <Row>
              {books}
            </Row>
          </InfiniteScroll>            
        </Container>
      )

    }


}

export default Books