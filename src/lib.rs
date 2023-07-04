use gloo::console::log;
use yew::prelude::*;
use serde::{Deserialize, Serialize};

mod component;
use component::main_header::MyTitle;

#[derive(Serialize, Deserialize)]
struct UserModel {
    id: i32,
    name: String,
}

#[function_component(App)]
pub fn app() -> Html {
    let message: Option<&str> = None;
        // Some("Hi Yvette!"); // */
    let list: Vec<&str> = vec!["Hi", "Hello", "Hallo", "Hola", "Bonjour"];

    html! {
        <>
            <head>
                <title>{"Hi Yvette"}</title>
            </head>
            <body>
                <main class="flex flex-col text-center">
                    <MyTitle title="LVC"/>
                    if let Some(message) = message {
                        <p>{message}</p>
                    } else {
                        <span>{"No message :("} </span>
                    }
                    <ul>
                        {list_to_html(list)}
                    </ul>
                </main>
            </body>
        </>
    }
}

fn list_to_html(list: Vec<&str>) -> Vec<Html> {
    let x = list.iter();
    let y = x.map(|item: &&str| html! { <li key={*item}>{item}{" Yvette!"}</li>});
    y.collect()
}