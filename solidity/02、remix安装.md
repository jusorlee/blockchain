运行Remix有两种方式,一种是直接用浏览器打开网址: https://remix.ethereum.org/  
另外一种方式就是在本地部署Remix服务, 顺序运行下面的命令:  
```
> git clone https://github.com/ethereum/remix
> cd remix
> npm install
> npm start
```

Remix服务就部署好了,然后在浏览器中打开:http://127.0.0.1:8080  
就可以直接使用本地部署Remix进行开发了.  

本地搭建Rmix 编辑器的好处,是可以随意修改编辑器中,源代码的字体.  


```
vim ./node_modules/brace/index.js
 
找到下面的内容:
var editorCss = ".ace_editor {\
    position: relative;\
    overflow: hidden;\
    font: 10px/normal 'Ubuntu Mono', 'Monaco', 'Menlo', 'Consolas', 'source-code-pro', monospace;\
    direction: ltr;\
}\
.ace_scroller {\
    position: absolute;\
    overflow: hidden;\
    top: 0;\
    bottom: 0;\
    background-color: inherit;\
    -ms-user-select: none;\
    -moz-user-select: none;\
    -webkit-user-select: none;\
    user-select: none;\
    cursor: text;\
}\
```

```
npm install
npm start
```