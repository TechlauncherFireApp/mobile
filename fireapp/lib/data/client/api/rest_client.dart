import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/models/token_request.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "https://api.fireapp-au.com/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/authentication/login")
  Future<TokenResponse> login(@Body() TokenRequest tokenRequest);

  @GET("/user/getAllVolunteer")
  Future<Map<String, String>> volunteerList();

  @GET("/reference/qualifications")
  Future<List<Qualification>> getQualifications();

}