import 'package:flutter/material.dart';
import 'dart:js' as js;


class RecipeDetailScreen extends StatelessWidget {
  final dynamic recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    List<dynamic> steps = recipe['analyzedInstructions'][0]['steps'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Detail'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/detail.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Image.network(
                  recipe['image'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe['title'],
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Price per Serving: \$${recipe['pricePerServing']}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Health Score: ${recipe['healthScore']}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Ready in Minutes: ${recipe['readyInMinutes']}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Servings: ${recipe['servings']}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Likes: ${recipe['aggregateLikes']}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'SUMMARY:',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          recipe['summary'],
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Dish Type:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(recipe['dishTypes'].length, (index) {
                            return Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                '${index + 1}. ${recipe['dishTypes'][index]}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Steps:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(steps.length, (index) {
                            dynamic step = steps[index];
                            String stepText = step['step'];
                            String ingredientsText = '';

                            List<dynamic> ingredients = step['ingredients'];
                            for (int i = 0; i < ingredients.length; i++) {
                              Map<String, dynamic> ingredient = ingredients[i];
                              String ingredientName = ingredient['name'];

                              if (i == ingredients.length - 1) {
                                ingredientsText += ingredientName;
                              } else {
                                ingredientsText += '$ingredientName, ';
                              }
                            }

                            return Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                '${index + 1}. $stepText\n   - Ingredients: $ingredientsText',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Information Source:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            String url = recipe['sourceUrl'];
                            js.context.callMethod('open', [url, '_blank']);
                          },
                          child: Text(
                            recipe['sourceUrl'],
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
