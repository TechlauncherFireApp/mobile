import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/models/reference/volunteer_role.dart';
import 'package:fireapp/domain/models/register_request.dart';
import 'package:fireapp/domain/models/token_request.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:fireapp/domain/models/dto/volunteer_information_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "https://api.fireapp-au.com/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST("/authentication/login")
  Future<TokenResponse> login(@Body() TokenRequest tokenRequest);

  @POST("/authentication/register")
  Future<TokenResponse> register(@Body() RegisterRequest registerRequest);

  @GET("/user/getAllVolunteer")
  Future<Map<String, String>> volunteerList();

  @GET("/reference/qualifications")
  Future<List<Qualification>> getQualifications();

  @GET("/reference/roles")
  Future<List<VolunteerRole>> getRoles();

  @GET("/volunteer")
  Future<VolunteerInformationDto> getVolunteerInformation(
      @Query("volunteerID") String volunteerId
  );
  @POST("/user-role")
  Future<void> updateVolunteerRoles(
      @Query("volunteerID") String volunteerId,
      @Body() List<String> roles
  );
}