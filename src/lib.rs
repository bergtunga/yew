use gloo::console::log;
use yew::{prelude::*, props};
use serde::{Deserialize, Serialize};

mod component;
use component::main_header::MyTitle;
use component::main_navigation::{MainNavigation, TabItem};

#[derive(Serialize, Deserialize)]
struct UserModel {
    id: i32,
    name: String,
}

#[function_component(App)]
pub fn app() -> Html {
    let message: Option<&str> = // None;
        Some("Hola Mi Amor!"); // */
    let list: Vec<&str> = vec!["Hi", "Hello", "Hallo", "Hola", "Bonjour"];
    let nav_items = props!(
        component::main_navigation::Props {
            items: vec![
                TabItem { text: "Active".to_owned(), is_disabled: false },
                TabItem { text: "TAB".to_owned(), is_disabled: false },
                TabItem { text: "tAb".to_owned(), is_disabled: false },
                TabItem { text: "tab".to_owned(), is_disabled: true }
            ],
            handle_newActive: Callback::from(|index: u32| {
                // log!("index changed", index)
            })
        }
    );
    html! {
        <>
            <head>
            <title>{"Hi Yvette"}</title>
            </head>
            <body>
                <MyTitle title="LVC"/>
                <MainNavigation ..nav_items />
                <main class="flex flex-col text-center">
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